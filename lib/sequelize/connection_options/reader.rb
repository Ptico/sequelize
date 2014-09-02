module Sequelize
  class ConnectionOptions

    class Reader

      attr_reader :connection_options

    private

      attr_reader :env, :config, :connection_config, :config_file

      def initialize(env='development', config=Sequelize.config)
        @env    = env.to_s
        @config = config

        get_connection_config
        setup_connection_options
      end

      def get_connection_config
        conf = config.connection ? config.connection.to_hash : read_db_config

        @connection_config = conf.each_with_object({}) do |pair, conf|
          conf[pair.first.to_sym] = pair.last
        end
      end

      def setup_connection_options
        @connection_options = ConnectionOptions[adapter_name].new(connection_config)
      end

      def adapter_name(name=connection_config[:adapter])
        case name
          when 'sqlite3'
            'sqlite'
          when /^do/
            adapter_name(name.replace(/^do_/, ''))
          when /^jdbc/
            'jdbc'
          when 'postgresql', 'pg'
            'postgres'
        else
          name
        end
      end

      def read_db_config
        if File.exist?(config_file)
          case File.extname(config_file)
            when '.yml', '.yaml'
              read_yaml_config
            when '.json'
              read_json_config
          end
        elsif ENV['DB'] || ENV['DATABASE_URL']
          read_env_config
        else
          fail('Database is not configured')
        end
      end

      def config_file
        @config_file ||= begin
          file = config.config_file

          file = 'config/database.yml' unless file
          File.join(config.root, file) if config.root
        end
      end

      def read_yaml_config
        require 'yaml'
        YAML.load_file(config_file)[env]
      end

      def read_json_config
        content = File.read(config_file)

        begin
          require 'multi_json'
          MultiJson.load(content)[env]
        rescue LoadError
          require 'json'
          JSON.load(content)[env]
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

    end

  end
end
