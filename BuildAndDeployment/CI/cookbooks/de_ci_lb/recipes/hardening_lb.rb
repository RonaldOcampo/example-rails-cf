hardening_rule "lb-admin-page-rule-tcp-in-#{node['haproxy']['admin']['port']}" do
  direction :in
  protocol :tcp
  source '0.0.0.0/0'
  port node['haproxy']['admin']['port'].to_i
end

hardening_rule "lb-incoming-port-rule-tcp-in-#{node['haproxy']['incoming_port']}" do
  direction :in
  protocol :tcp
  source '0.0.0.0/0'
  port node['haproxy']['incoming_port'].to_i
end

hardening_rule "lb-ssl-incoming-port-rule-tcp-in-#{node['haproxy']['ssl_incoming_port']}" do
  direction :in
  protocol :tcp
  source '0.0.0.0/0'
  port node['haproxy']['ssl_incoming_port'].to_i
end
