module Sequelize
  class ConnectionOptions
    class Sqlite < Base
      ConnectionOptions.register(:sqlite, self)

      def adapter
        :sqlite
      end

      def database
        super || config[:path]
      end
    end
  end
end
