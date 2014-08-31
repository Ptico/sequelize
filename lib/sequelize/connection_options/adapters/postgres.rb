module Sequelize
  class ConnectionOptions
    class Postgres < Base
      ConnectionOptions.register(:postgres, self)

      def adapter_name
        :postgres
      end

      def encoding
        config[:encoding] || charset
      end
      property :encoding

      def locale
        config[:locale]
      end
      property :locale

      def ctype
        config[:ctype]
      end
      property :ctype

      def template
        config[:template]
      end
      property :template

      def tablespace
        config[:tablespace]
      end
      property :tablespace

      def maintenance_db
        config[:maintenance_db]
      end
      property :maintenance_db

    end
  end
end
