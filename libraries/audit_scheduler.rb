# encoding: utf-8
module Audit
  class AuditScheduler
    def initialize(interval_enabled, interval_time)
      @interval_enabled = interval_enabled
      @interval_time = interval_time
    end

    def should_skip_audit?
      if should_run_on_schedule?
        if scheduled_to_run?
          Chef::Log.warn 'Running the compliance audit of this node since it is set to run '\
            "every #{schedule_interval} seconds and last ran on #{last_run_time}."
        else
          Chef::Log.warn 'Skipping The compliance audit of this node since it is set to run '\
            "every #{schedule_interval} seconds and is scheduled to run during a chef-client "\
            "run after #{next_scheduled_time}"
          return true
        end
      else
        Chef::Log.warn 'Running the compliance audit of this node every time chef-client runs.'\
          'To change this, configure it to run on an interval'
      end
      false
    end

    def record_completed_run
      FileUtils.touch schedule_file
    end

    def should_run_on_schedule?
      @interval_enabled
    end

    def schedule_interval
      @interval_time
    end

    def scheduled_to_run?
      schedule_file_modified = ::File.mtime(schedule_file)
      seconds_since_last_run = Time.now - schedule_file_modified
      scheduled = schedule_interval < seconds_since_last_run
      Chef::Log.debug "Run scheduled is #{scheduled} where interval is set to #{schedule_interval} "\
        "and it has been #{seconds_since_last_run} seconds since #{schedule_file} last ran "\
        "at #{schedule_file_modified}"
    end

    def schedule_file
      ::File.join(Chef::Config[:file_cache_path], 'compliance', 'schedule')
    end
  end
end
