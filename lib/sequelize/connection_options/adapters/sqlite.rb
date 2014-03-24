module Sequelize
  class ConnectionOptions
    class Sqlite < Base
      ConnectionOptions.register(:sqlite, self)

      def adapter_name
        :sqlite
      end

      def database
        super || config[:path]
      end
    end
  end
end
