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
      @config = build(env)

      setup_connection_options(env)
    end

  private

    def setup_connection_options(env)
      connection_conf = read_db_config(env)
      connection_adapter = normalize_adapter_name(connection_conf['adapter'])

      @connection_options = ConnectionOptions[connection_adapter].new(connection_conf)
    end

    def read_db_config(env)
      file = config.config_file

      file = 'config/database.yml' unless file
      file = File.join(config.root, file) if config.root

      if File.exists?(file)
        case File.extname(file)
          when '.yml', '.yaml'
            read_yaml_config(file, env)
          when '.json'
            read_json_config(file, env)
        end
      else
        read_env_config
      end
    end

    def read_yaml_config(file, env)
      require 'yaml'
      YAML.load_file(file)[env.to_s]
    end

    def read_json_config(file, env)
      content = File.read(file)

      begin
        require 'multi_json'
        MultiJson.load(content)[env.to_s]
      rescue LoadError
        require 'json'
        JSON.load(content)[env.to_s]
      end
    end

    def read_env_config
      require 'uri'

      url_string = ENV['DB'] || ENV['DATABASE_URL']
      url = URI.parse(url_string)

      {
        'adapter'  => url.scheme,
        'username' => url.user,
        'password' => url.password,
        'host'     => url.host,
        'port'     => url.port,
        'dbname'   => url.path[1..-1]
      }
    end

    def normalize_adapter_name(name)
      case name
        when 'sqlite3'
          'sqlite'
        when /^do/
          normalize_adapter_name(name.replace(/^do_/, ''))
        when /^jdbc/
          'jdbc'
        when 'postgresql', 'pg'
          'postgres'
      else
        name
      end
    end

  end
end
