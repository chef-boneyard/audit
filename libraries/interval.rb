# encoding: utf-8

def profile_overdue_to_run?(profile, interval)
  # Calculate when the profile was last run so we delay it's next run if necessary
  compliance_cache_directory = ::File.join(Chef::Config[:file_cache_path], 'compliance')
  return true unless ::File.exist?("#{compliance_cache_directory}/#{profile}")
  seconds_since_last_run = Time.now - ::File.mtime("#{compliance_cache_directory}/#{profile}")
  seconds_since_last_run > interval
end
