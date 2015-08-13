override['swift']['url'] = 'http://artifactory.mia.ucloud.int/artifactory/ultimate-local'

default['haproxy']['enabled'] = '1'

default[:haproxy][:defaults_timeouts][:connect] = '60s'
default[:haproxy][:defaults_timeouts][:client] = '120s'
default[:haproxy][:defaults_timeouts][:server] = '120s'

default[:haproxy][:defaults_options] = ['httplog', 'http-server-close', 'dontlognull', 'redispatch']
default[:haproxy][:defaults_errorfiles]['503'] =  '/var/www/503maintenance.http'

default[:haproxy][:member_port] = '80'

override[:haproxy][:admin][:address_bind] = '0.0.0.0'

default[:de_ci_lb][:key_server_common] = node[:paas_agent][:key_server_common]
default[:de_ci_lb][:ssl_file] = node[:paas_agent][:ssl_private_key]