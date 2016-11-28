# encoding: utf-8

# module AutomateHelpers
  def dc_token
    @dc_token ||= JSON.parse(File.read('/etc/delivery/delivery-running.json'))['delivery']['data_collector']['token']
  end
# end
#
# ::Chef::Recipe.send(:include, AutomateHelpers)
