# encoding: utf-8

def last_run(profile, interval)
  # Calculate when the profile was last run so we delay it's next run if necessary
  return false unless ::File.exist?("#{compliance_cache_directory}/#{profile}")
  compliance_cache_directory = ::File.join(Chef::Config[:file_cache_path], 'compliance')
  lastrun = Time.now - ::File.mtime("#{compliance_cache_directory}/#{profile}")
  lastrun < interval
end
