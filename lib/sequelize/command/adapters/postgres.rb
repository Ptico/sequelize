module Sequelize
  class Command
    class Postgres < Base
      Command.register(:postgres, self)

      def create
        run('createdb') do
          add_connection_settings

          option '--maintenance-db', options.maintenance_db
          option '--encoding',       options.encoding
          option '--locale',         options.locale
          option '--lc-collate',     options.collation
          option '--lc-ctype',       options.ctype
          option '--template',       options.template
          option '--tablespace',     options.tablespace
          option '--owner',          options.owner

          flag options.database
        end
      end

      def drop
        run('dropdb') do
          add_connection_settings

          flag options.database
        end
      end

      def dump_schema(filename)
        run('pg_dump') do
          add_connection_settings

          flag '--schema-only'
          add_dump_options filename
        end
      end

      def dump(filename)
        run('pg_dump') do
          add_connection_settings

          add_dump_options filename
        end
      end

      def load(filename)
        run('psql') do
          add_connection_settings

          option '--file', filename
          flag options.database
        end
      end

      def console
        run_and_quit('psql') do
          add_connection_settings
          flag options.database
        end
      end

    private

      def execute(command)
        with_pgpassword do
          super
        end
      end

      def with_pgpassword
        ENV['PGPASSWORD'] = options.password unless options.password.empty?
        yield
      ensure
        ENV['PGPASSWORD'] = nil unless options.password.empty?
      end

      def add_connection_settings
        option '--username', options.username
        option '--host',     options.host
        option '--port',     options.port
      end

      def add_dump_options(filename)
        flag '--no-privileges'
        flag '--no-owner'
        option '--file', filename
        flag options.database
      end

    end
  end
end
