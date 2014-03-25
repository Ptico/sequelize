module Sequelize
  class Command
    class Sqlite < Base
      include Memoizable

      Command.register(:sqlite, self)

      def create
        unless in_memory?
          File.open(db_path, 'w')
        end
      end

      def drop
        FileUtils.rm(db_path)
      end

      def dump_schema(filename)
        run('sqlite3') do
          flag db_path
          flag '.schema'
          option '>', filename
        end
      end

      def dump(filename)
        run('sqlite3') do
          flag db_path
          flag '.dump'
          option '>', filename
        end
      end

      def load(filename)
        run('sqlite3') do
          flag db_path
          option '<', filename
        end
      end

      private

      def in_memory?
        options.database == ':memory:'
      end
      memoize :in_memory?

      def db_path
        unless in_memory?
          root = Sequelize.config.connection.root
          root ? File.join(root, options.database) : options.database
        end
      end
      memoize :db_path

    end
  end
end
