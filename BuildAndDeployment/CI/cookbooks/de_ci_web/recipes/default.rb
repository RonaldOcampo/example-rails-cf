#
# Cookbook Name:: de_ci_web
# Recipe:: default
#
# Copyright 2015, Ultimate Software
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'spade'

class Chef::Resource
  include ConfigFiles
end

%w(
  ruby1.9.3
  bundler
  zlib1g-dev
  libsqlite3-dev
  ruby-execjs
).each { |pkg|
  package pkg do
    action :install
  end
}

include_recipe 'de_ci_web::hardening_web'

artifact = 'WebApp.zip'
web_directory = node[:de_ci_web][:web_directory]
root_directory = Chef::Config[:file_cache_path]

directory web_directory do
  recursive true
end

remote_file File.join(root_directory, artifact) do
  source "#{node.binaries.url}/#{node.product.project_code}/#{node.product.binaries_revision}/#{artifact}"
  retries 3
  retry_delay 10
end

execute "unzip #{root_directory}/#{artifact} -d #{web_directory}" do
  not_if { Dir.exists? "#{web_directory}/bin" }
end

execute "chmod -R 755 #{web_directory}/*"

execute 'bundle install' do
  cwd web_directory
end

ruby_block 'Updating mongo settings in config files' do
  block do
    update_mongo_settings
  end
end

execute 'bin/rake db:migrate' do
  cwd web_directory
end

execute "bin/rails server -b #{node['ipaddress']} -p #{node[:paas_agent][:webapp_port]} &" do
  cwd web_directory
  not_if { `ps -ef | grep 'bin/rails server'`.count('\n') > 2 }
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