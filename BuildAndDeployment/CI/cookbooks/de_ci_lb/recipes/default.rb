#
# Cookbook Name:: de_ci_lb
# Recipe:: default
#
# Copyright 2015, Ultimate Software
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'spade'
include_recipe 'de_ci_lb::hardening_lb'

web_nodes = find_services('web_server').collect{ |x| x['descriptor'] }

web_nodes.map! do |member|
  {
      ipaddress: member['ipaddress'],
      hostname: member['hostname']
  }
end

directory "#{node['haproxy']['source']['prefix']}/etc/haproxy" do
  recursive true
end

remote_file "#{node['haproxy']['source']['prefix']}/etc/haproxy/#{node[:de_ci_lb][:ssl_file]}" do
  source "#{node[:de_ci_lb][:key_server_common]}#{node[:de_ci_lb][:ssl_file]}"
  owner 'root'
  group 'root'
  mode 0400
end

directory '/var/www' do
  recursive true
end

cookbook_file '/var/www/503maintenance.http' do
  source '503maintenance.http'
  mode 0755
end

template "#{node['haproxy']['conf_dir']}/haproxy.cfg" do
  source 'haproxy-web_lb.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
      pool_members: web_nodes.uniq,
      defaults_options: node[:haproxy][:defaults_options],
      defaults_timeouts: node[:haproxy][:defaults_timeouts],
      defaults_errorfiles: node[:haproxy][:defaults_errorfiles],
      ssl_file: node[:de_ci_lb][:ssl_file]
  )
  notifies :reload, 'service[haproxy]'
end

service 'haproxy' do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

spade_service 'lb' do
  type 'load_balancer'
  descriptor ({
       'ipaddress' => node['ipaddress'],
       'hostname' => node.hostname,
       'fqdn' => "#{node.hostname}.#{node[:paas_agent][:domain]}",
       'version' => node['product']['binaries_revision]']
   })
end