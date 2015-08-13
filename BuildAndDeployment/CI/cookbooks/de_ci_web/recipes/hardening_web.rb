hardening_rule 'web-mongodb-tcp-out' do
  direction :out
  protocol :tcp
  port 27017
end

hardening_rule 'web-https-tcp-out' do
  direction :out
  protocol :tcp
  port 443
  destination 'any'
end

hardening_rule 'web-http-tcp-out' do
  direction :out
  protocol :tcp
  port 80
  destination 'any'
end