# encoding: utf-8

module Audit
  class HttpProcessor
    def self.handle_http_error_code(code)
      case code
      when /401/
        Chef::Log.error 'Possible time/date issue on the client.'
      when /403/
        Chef::Log.error 'Possible offline Compliance Server or chef_gate auth issue.'
      when /404/
        Chef::Log.error 'Object does not exist on remote server.'
      end
      error_message = 'Could not fetch the profile. Verify the authentication (e.g. token) is set properly'
      Chef::Log.error error_message
      fail error_message
    end

    #rubocop:disable all
    def self.with_http_rescue(&block)
      begin
        response = yield
        if response.respond_to?(:code)
          # handle non 200 error codes, they are not raised as Net::HTTPServerException
          handle_http_error_code(response.code) if response.code.to_i >= 300
        end
        return response
      rescue Net::HTTPServerException => e
        handle_http_error_code(e.response.code)
      end
    end  
  end
end