# encoding: utf-8
require 'json'

module Reporter
  #
  # Used to write report to file on disk
  #
  class JsonFile
    def initialize(opts)
      @opts = opts
    end

    def send_report(report)
      write_to_file(report, @opts[:file])
    end

    def write_to_file(report, path)
      json_file = File.new(path, 'w')
      json_file.puts(report)
      json_file.close
    end
  end
end
