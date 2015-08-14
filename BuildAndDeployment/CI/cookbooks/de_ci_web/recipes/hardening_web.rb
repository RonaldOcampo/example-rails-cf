hardening_rule 'web-mongodb-tcp-out' do
  direction :out
  protocol :tcp
  port 27017
end

hardening_rule "webapp-tcp-in-#{node[:paas_agent][:webapp_port]}" do
  direction :in
  protocol :tcp
  port node[:paas_agent][:webapp_port].to_i
end