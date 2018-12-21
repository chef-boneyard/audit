name "audit-test"
run_list "audit::default"

default_source :supermarket

default['audit']['reporter'] = 'json-file'
default['audit']['profiles']['linux-patch-baseline'] = { 'url': 'https://github.com/dev-sec/linux-patch-baseline/archive/0.4.0.zip' }
default['audit']['profiles']['ssh-baseline'] = { 'supermarket': 'dev-sec/ssh-baseline' }
