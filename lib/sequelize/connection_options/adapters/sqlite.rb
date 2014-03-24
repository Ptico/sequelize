module Sequelize
  class ConnectionOptions
    class Sqlite < Base
      ConnectionOptions.register(:sqlite, self)

      def database
        super || config[:path]
      end
    end
  end
end
