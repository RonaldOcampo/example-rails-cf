module ConfigFiles
  def replace_text_in_files(list, source, target)
    list.each { |file| replace_text_in_file(file, source, target) }
  end

  def replace_text_in_file(file, source, target)
    text = File.read(file)
    modified = text.gsub(/#{source}/, target)
    File.open(file, 'w') { |f| f.puts(modified) }
  end

  def update_mongo_settings
    mongo_replicaset_host_string = mongo_replicaset_hosts
    Chef::Log.info("Using database replicaset hosts: #{mongo_replicaset_host_string}")

    replace_text_in_files config_files, 'Mongo::Connection.*$', "Mongo::MongoReplicaSetClient.new(#{mongo_replicaset_host_string})"
  end

  private
  def config_files
    Dir.glob("#{node[:de_ci_web][:web_directory]}/**/mongo_config.rb")
  end

  def mongo_replicaset_hosts
    mongos = find_services('mongodb').collect{ |x| x['descriptor'] }

    replicaset_nodes = mongos.collect{|mongo_node| "#{mongo_node['ipaddress']}:#{mongo_node['port']}"}
    replicaset_nodes.to_s
  end
end
