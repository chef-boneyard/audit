# encoding: utf-8

def last_run(profile, interval)
  # Calculate when the profile was last run so we delay it's next run if necessary
  compliance_cache_directory = ::File.join(Chef::Config[:file_cache_path], 'compliance')
  if ::File.exist?("#{compliance_cache_directory}/#{profile}")
    lastrun = Time.now - ::File.mtime("#{compliance_cache_directory}/#{profile}")
    return lastrun < interval
  else
    return false
  end
end
