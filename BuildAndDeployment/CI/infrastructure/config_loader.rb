require 'json'

class ConfigLoader

  def self.load(arguments = {})
    config = OpenStruct.new JSON.parse(File.read("#{File.dirname(__FILE__)}/../config.json"))

    find_config_keys_in_env(config).each do |key, value|
      eval "config.#{key} = '#{value}'"
    end

    find_config_keys_in_arguments(config, arguments).each do |key, value|
      eval "config.#{key} = '#{value}'"
    end

    config.deployment_owner = 'TeamCity' if config.deployment_owner == '%build.triggeredBy.username%'

    verify_config_parameters config

    config
  end

  private
  def self.verify_config_parameters(config)
    config.marshal_dump.each do |key, value|
      raise "Parameter #{key} cannot be empty." if value.to_s.empty? && !keys_allowed_to_be_blank.member?(key)
    end
  end

  def self.find_config_keys_in_env(config)
    result ={}
    config.marshal_dump.each do |key, value|
      key_with_dot = key.to_s.gsub('_', '.')
      result[key] = ENV[key_with_dot] unless ENV[key_with_dot].nil?
      result[key] = ENV[key.to_s] unless ENV[key.to_s].nil?
    end
    result
  end

  def self.find_config_keys_in_arguments(config, arguments)
    result ={}
    config.marshal_dump.each do |key, value|
      result[key] = arguments[key] unless arguments[key].nil?
    end
    result
  end

  def self.should_seed_name?(config)
    %w(ci ui).include? config.deployment_type
  end

  def self.keys_allowed_to_be_blank
    [:zone_list, :onboarding_base_url, :dns_alias, :rabbitmq_api_url_previous]
  end
end