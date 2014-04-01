require 'sequelize/version'

require 'sequel'
require 'adamantium'
require 'sequoia'

require 'sequelize/connection_options'

module Sequelize

  class << self
    include Sequoia::Configurable

    attr_reader :config, :connection_options

    def setup(env=:development)
      @config = build_configuration(env)

      setup_connection_options(env)
    end

    def connection
      @connection ||= connect!
    end

    def connect!
      Sequel.connect(options)
    end

  private
    ADDITIONAL_OPTIONS_KEYS = Set.new([:logger, :after_connect]).freeze

    def setup_connection_options(env)
      @connection_options = ConnectionOptions::Reader.new(env, config).connection_options
    end

    def options
      connection_options.to_hash.merge(additional_options)
    end

    def additional_options
      source_config = config.to_hash
      ADDITIONAL_OPTIONS_KEYS.each_with_object({}) do |key, result|
        result[key] = source_config[key] if source_config.has_key? key
      end
    end

  end
end
