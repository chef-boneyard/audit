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
        profile_path = "/compliance/profiles/#{owner}/#{id}/tar"
        dc = Chef::Config[:data_collector]
        url = URI(dc[:server_url])
        url.path = profile_path
        profile_fetch_url = url.to_s
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
      if URI(profile).scheme == 'compliance'
        uri = URI(profile)
      else
        uri = URI("compliance://#{profile}")
      end
      uri.to_s.sub(%r{^compliance:\/\/}, '')
    end

    def initialize(url, opts)
      options = {
        'insecure' => true,
        'token' => opts['token'],
        'server_type' => 'automate',
        'automate' => {
          'ent' => '',
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
