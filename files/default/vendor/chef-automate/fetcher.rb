module ChefAutomate
  class Fetcher < Compliance::Fetcher
    name 'chef-automate'

    # it positions itself before `compliance` fetcher
    # only load it, if you want to use audit cookbook in Chef Solo with Chef Automate
    priority 502

    def self.resolve(target)
      uri = if target.is_a?(String) && URI(target).scheme == 'compliance'
              URI(target)
            elsif target.respond_to?(:key?) && target.key?(:compliance)
              URI("compliance://#{target[:compliance]}")
            end

      return nil if uri.nil?

      # we have detailed information available in our lockfile, no need to ask the server
      if target.respond_to?(:key?) && target.key?(:url)
        profile_fetch_url = target[:url]
        config = {}
      else
        # verifies that the target e.g base/ssh exists
        profile = sanitize_profile_name(uri)
        owner, id = profile.split('/')
        profile_path = if target.respond_to?(:key?) && target.key?(:version)
                         "/compliance/profiles/#{owner}/#{id}/version/#{target[:version]}/tar"
                       else
                         "/compliance/profiles/#{owner}/#{id}/tar"
                       end
        dc = Chef::Config[:data_collector]
        url = URI(dc[:server_url])
        url.path = profile_path
        profile_fetch_url = url.to_s

        raise 'No data-collector token set, which is required by the chef-automate fetcher. ' \
          'Set the `data_collector.token` configuration parameter in your client.rb ' \
          'or use the "chef-server-automate" reporter which does not require any ' \
          'data-collector settings and uses Chef Server to fetch profiles.' if dc[:token].nil?

        config = {
          'token' => dc[:token],
        }
      end

      new(profile_fetch_url, config)
    rescue URI::Error => _e
      nil
    end

    # returns a parsed url for `admin/profile` or `compliance://admin/profile`
    # TODO: remove in future, copied from inspec to support older versions of inspec
    def self.sanitize_profile_name(profile)
      uri = if URI(profile).scheme == 'compliance'
              URI(profile)
            else
              URI("compliance://#{profile}")
            end
      uri.to_s.sub(%r{^compliance:\/\/}, '')
    end

    def initialize(url, opts)
      options = {
        'insecure' => true,
        'token' => opts['token'],
        'server_type' => 'automate',
        'automate' => {
          'ent' => 'default',
          'token_type' => 'dctoken',
        },
      }
      super(url, options)
    end

    def to_s
      'Chef Automate for Chef Solo Fetcher'
    end
  end
end
