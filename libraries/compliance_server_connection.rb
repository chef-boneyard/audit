# encoding: utf-8

require 'uri'

module Audit
  class ComplianceServerConnection
    attr_accessor :server, :token, :refresh_token

    def initialize(server, owner, token, refresh_token)
      fail 'Connection needs a server' if server.nil?
      fail 'Owner where the node is to be reported must be defined' if owner.nil?

      server += '/' unless server.end_with? '/'
      @server = server
      @owner = owner
      @token = token
      @refresh_token = refresh_token
      Chef::Log.debug "Connecting to compliance server: #{server} with owner: #{owner}"
    end

    def fetch(profile)
      reqpath ="owners/#{profile.owner}/compliance/#{profile.name}/tar"
      url = construct_url(server, reqpath)
      Chef::Log.warn "Load #{profile} from compliance server: #{url}"
      tf = Tempfile.new('foo', Dir.tmpdir, 'wb+')
      tf.binmode
      opts = { use_ssl: url.scheme == 'https',
               verify_mode: OpenSSL::SSL::VERIFY_NONE, # FIXME
      }
      Net::HTTP.start(url.host, url.port, opts) do |http|
        resp = ::Audit::HttpProcessor.with_http_rescue do
          http.get(url.path, 'Authorization' => "Bearer #{access_token}")
        end
        tf.write(resp.body)
      end
      tf.flush
    end

    def access_token
      if refresh_token.nil?
        token
      else
        retrieve_access_token
      end
    end

    def retrieve_access_token(url, refresh_token)
      _success, _msg, access_token = Compliance::API.post_refresh_token(url, refresh_token, options['insecure'])
      # TODO: we return always the access token, without proper error handling
      access_token
    end

    def construct_url(server, path)
      path.sub!(%r{^/}, '') # sanitize input
      server = URI(server)
      server.path = server.path + path if path
      server
    end

    def report(report_results)
      Chef::Log.info "Reporting results of run to owner #{owner} on compliance server"
      url = construct_url(server, ::File.join('/owners', owner, 'inspec'))
      req = Net::HTTP::Post.new(url, { 'Authorization' => "Bearer #{access_token}" })
      req.body = report_results.to_json
      Chef::Log.info "Report to: #{url}"

      opts = { use_ssl: url.scheme == 'https',
               verify_mode: OpenSSL::SSL::VERIFY_NONE, # FIXME
      }
      Net::HTTP.start(url.host, url.port, opts) do |http|
        ::Audit::HttpProcessor.with_http_rescue do
          http.request(req)
        end
      end
    end
  end
end
