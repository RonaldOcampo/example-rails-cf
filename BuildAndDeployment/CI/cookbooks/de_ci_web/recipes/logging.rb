directory node[:de_ci_web][:log_dir] do
  recursive true
end

file "#{node[:de_ci_web][:log_dir]}/#{node[:de_ci_web][:log_file]}" do
  mode '0644'
end

template '/etc/rsyslog.d/66-bloq.conf' do
  source '66-bloq.conf.erb'
  variables(
      :logging_bloq_path => "#{node[:de_ci_web][:log_dir]}/#{node[:de_ci_web][:log_file]}"
  )
  backup false
  mode 0644
  notifies :restart, 'service[rsyslog]'
end

service 'rsyslog' do
  action :nothing
end