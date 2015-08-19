require 'rest-client'
require 'json'

cifs_data = JSON.parse(RestClient.get("#{node[:de_ci_db][:key_server_common]}/#{node[:de_ci_db][:cifs_data]}"))

directory node[:de_ci_db][:backup_location] do
  recursive true
  action :create
end

template '/usr/local/bin/mongodb-backup.sh' do
  mode '0700'
  variables(
      username: cifs_data['username'],
      password: cifs_data['password'],
      backup_device: node[:de_ci_db][:backup_device],
      backup_location: node[:de_ci_db][:backup_location]
  )
end
