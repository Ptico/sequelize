module Sequelize
  class ConnectionOptions
    class Mysql < Base
      ConnectionOptions.register(:mysql, self)

      def adapter
        :mysql
      end

      def collation
        super || 'utf8_unicode_ci'
      end
    end
  end
end
