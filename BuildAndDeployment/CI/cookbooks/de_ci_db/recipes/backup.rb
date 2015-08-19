include_recipe 'de_ci_db::cifs_backup'

if node[:de_ci_db][:enable_backup_schedule] == 'true' && node.hostname.end_with?('member-2')
  cron 'mongodb-backup' do
    minute '30'
    hour '0,4,8,12,16,20'
    day '*'
    weekday '*'
    command '/usr/local/bin/mongodb-backup.sh'
    action :create
  end
end
