module Sequelize
  class Command
    class Postgres < self
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

    private

      def execute(command)
        with_pgpassword do
          super
        end
      end

      def with_pgpassword
        ENV['PGPASSWORD'] = options.password unless options.password.blank?
        yield
      ensure
        ENV['PGPASSWORD'] = nil unless options.password.blank?
      end

      def add_connection_settings
        option '--username', options.username
        option '--host',     options.host
        option '--port',     options.port.to_s
      end

    end
  end
end
