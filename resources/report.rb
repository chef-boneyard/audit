# encoding: utf-8

include ReportHelpers
provides :inspec_report
resource_name :inspec_report

property :collector, String, default: 'chef-visibility'

default_action :execute

action :execute do
  case collector
  when 'chef-visibility'
    Collector::ChefVisibility.new(entity_uuid, run_id, run_context.node.name).send_report
  end
end
