hardening_rule 'db-default' do
  direction :in
  protocol :tcp
  port 27017
end

hardening_rule 'db-backup' do
  direction :out
  protocol :tcp
  port 445
end
