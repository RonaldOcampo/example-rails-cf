#
# Cookbook Name:: de_ci_web
# Recipe:: default
#
# Copyright 2015, Ultimate Software
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'de_ci_web::hardening_web'

bin_dir = '/var/www'
artifact = 'WebApp.zip'
root_directory = Chef::Config[:file_cache_path]

directory bin_dir

remote_file File.join(root_directory, artifact) do
  source "#{node.binaries.url}/#{node.product.project_code}/#{node.product.binaries_revision}/#{artifact}"
  retries 3
  retry_delay 10
end

spade_service 'web_server' do
  type 'web_server'
  descriptor ({
       'ipaddress' => node['ipaddress'],
       'hostname' => node.hostname,
       'fqdn' => "#{node.hostname}.#{node[:paas_agent][:domain]}",
       'version' => node['product']['binaries_revision']
   })
end