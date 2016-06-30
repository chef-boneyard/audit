# encoding: utf-8

require 'uri'

module Audit
  class ComplianceProfile
    attr_reader :owner, :name, :enabled, :connection
    attr_accessor :path

    # rubocop:disable ParameterLists
    def initialize(owner, name, enabled, path, connection, platform_windows, quiet)
      @owner = owner
      @name = name
      @enabled = enabled
      @path = path
      @connection = connection
      @platform_windows = platform_windows
      @quiet = quiet
    end

    def platform_windows?
      @platform_windows
    end

    def full_name
      "#{owner}/#{name}"
    end

    def to_s
      "Compliance profile #{full_name}"
    end

    def compliance_cache_path
      ::File.join(Chef::Config[:file_cache_path], 'compliance')
    end

    def tar_path
      return path if path
      ::File.join(compliance_cache_path, "#{owner}_#{name}.tgz")
    end

    def report_path
      ::File.join(compliance_cache_path, "#{owner}_#{name}_report.json")
    end

    def fetch
      return if path # will be fetched from other source during execute phase
      Chef::Log.info "Fetching #{self}"
      file = connection.fetch(self)
      move_profile_to_cache file
    end

    def move_profile_to_cache(file)
      path = tar_path
      Chef::Log.debug "Moving downloaded #{self} to cache destination: #{path}"
      if platform_windows?
        # mv replaced due to Errno::EACCES:
        # https://bugs.ruby-lang.org/issues/10865
        FileUtils.cp(file.path, path) unless file.nil?
      else
        FileUtils.mv(file.path, path) unless file.nil?
      end
    end

    def execute
      path ||= tar_path
      supported_schemes = %w{http https supermarket compliance chefserver}
      if !supported_schemes.include?(URI(path).scheme) && !::File.exist?(path)
        Chef::Log.warn "No such path! Skipping: #{path}"
        fail "Aborting since profile is not present here: #{path}"
      end
      Chef::Log.info "Executing: #{path}"
      output = @quiet ? ::File::NULL : $stdout
      runner = ::Inspec::Runner.new('report' => true, 'format' => 'json-min', 'output' => output)
      runner.add_target(path, {})
      begin
        runner.run
      rescue Chef::Exceptions::ValidationFailed => e
        log "INSPEC Validation Failed: #{e}"
      end
      report = ::JSON.parse(runner.report.to_json)
      summary = report['summary']
      Chef::Log.warn "Result of running #{self}: #{summary['failure_count']}/#{summary['example_count']} failed,"\
            " #{summary['skip_count']} skipped."
      report
    end
  end
end
