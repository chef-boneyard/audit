
include_recipe 'kitchen-automate::harakiri'
include_recipe 'kitchen-automate::configure_services'
include_recipe 'kitchen-automate::upload_profile'
include_recipe 'kitchen-automate::bootstrap_localhost'
include_recipe 'kitchen-automate::converge_localhost'
