# encoding: utf-8

require 'chef/handler'

module Reporter
  #
  # Used to raise an error on conformance failure
  #
  class Cli

    def send_report(report)
      # iterate over each profile and control
      output = []
      report[:profiles].each do |profile|
        next if profile[:controls].nil?
        output << "\n"
        output << profile[:title]
        profile[:controls].each do |control|
          next if control[:results].nil?
          output << "\t#{control[:title]}"
          control[:results].each do |result|
            if result[:status] == 'failed'
              found = false
              if result[:code_desc]
                found = true
                output << "\t\t\033[31m\xE2\x9D\x8C #{result[:code_desc]}\033[0m"
              end
              if result[:message]
                if found
                  result[:message].split(/\n/).each do |m|
                    next if m.empty?
                    output << "\t\t\t\033[31m#{m}\033[0m"
                  end
                else
                  prefix = "\xE2\x9D\x8C"
                  result[:message].split(/\n/).each do |m|
                    next if m.empty?
                    output << "\t\t\033[31m#{prefix}#{m}\033[0m"
                    prefix = ""
                  end
                end
                found = true
              end
              unless found
                output << "\t\t\033[31m\xE2\x9D\x8C #{result[:status]}\033[0m"
              end
            else
              found = false
              if result[:code_desc]
                found = true
                output << "\t\t\033[32m\xE2\x9C\x94 #{result[:code_desc]}\033[0m"
              end
              unless found
                output << "\t\t\033[32m\xE2\x9C\x94 #{result[:status]}\033[0m"
              end
            end
          end
        end
      end
      output << "\n"
      puts output.join("\n")
    end
  end
end
