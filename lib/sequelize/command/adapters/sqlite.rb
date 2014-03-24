module Sequelize
  class Command
    class Sqlite < Base
      Command.register(:sqlite, self)

      def create
        if options.database!=':memory:'
          @db_path = File.join(Sequelize.config.connection.root, options.database)
          File.open(@db_path, 'w') {}
        end
      end

      def drop
        FileUtils.rm(@db_path)
      end

      def dump(filename)
        run('sqlite3') do
          flag @db_path
          flag '.schema >'
          flag filename
        end
      end

      def load(filename)
        run('sqlite3') do
          flag @db_path
          flag '<'
          flag filename
        end
      end
    end
  end
end
