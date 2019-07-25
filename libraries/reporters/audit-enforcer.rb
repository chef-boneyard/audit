# encoding: utf-8

module Reporter
  #
  # Used to raise an error on conformance failure
  #
  class AuditEnforcer
    class ControlFailure < StandardError; end

    def send_report(report)
      # iterate over each profile and control
      report[:profiles].each do |profile|
        next if profile[:controls].nil?
        profile[:controls].each do |control|
          next if control[:results].nil?
          control[:results].each do |result|
            raise ControlFailure, "Audit #{control[:id]} has failed. Aborting chef-client run." if result[:status] == 'failed'
          end
        end
      end
      true
    end
  end
end
