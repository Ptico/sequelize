module Sequelize
  class Command
    class Mysql < Base
      Command.register(:postgres, self)

      def create
        run('mysql') do
          add_connection_settings
          option '--execute', "CREATE DATABASE IF NOT EXISTS #{options.database} DEFAULT CHARACTER SET #{options.charset} DEFAULT COLLATE #{options.collation}"
        end

      end

      def drop
        run('mysql') do
          add_connection_settings
          option '--execute', "DROP DATABASE IF EXISTS #{options.database}"
        end
      end

      def dump_schema(filename)
        run('mysqldump') do
          add_connection_settings

          flag '--no-data'
          option '--result-file', filename
          flag options.database
        end
      end

      def dump(filename)
        run('mysqldump') do
          add_connection_settings

          option '--result-file', filename
          flag options.database
        end
      end

      def load(filename)
        run('mysql') do
          add_connection_settings

          option '--database', options.database
          option '--execute', "SET FOREIGN_KEY_CHECKS = 0; SOURCE #{filename}; SET FOREIGN_KEY_CHECKS = 1"
        end
      end

      def console
        run_and_quit('mysql') do
          add_connection_settings

          flag options.database
        end
      end

    private

      def add_connection_settings
        option '--user',     options.username
        option '--password', options.password
        option '--host',     options.host
        option '--port',     options.port
      end
    end
  end
end