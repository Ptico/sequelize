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
      Sequel.connect(connection_options.to_hash)
    end

  private

    def setup_connection_options(env)
      @connection_options = ConnectionOptions::Reader.new(env, config).connection_options
    end

  end
end
