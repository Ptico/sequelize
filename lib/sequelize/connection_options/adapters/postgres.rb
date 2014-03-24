module Sequelize
  class ConnectionOptions
    class Postgres < Base
      ConnectionOptions.register(:postgres, self)

      def adapter
        :postgres
      end

      def encoding
        config[:encoding] || charset
      end
      memoize :encoding

      def locale
        config[:locale]
      end
      memoize :locale

      def ctype
        config[:ctype]
      end
      memoize :ctype

      def template
        config[:template]
      end
      memoize :template

      def tablespace
        config[:tablespace]
      end
      memoize :tablespace

      def maintenance_db
        config[:maintenance_db]
      end
      memoize :maintenance_db

    private

      def properties
        super + [:encoding, :locale, :ctype, :template, :tablespace, :maintenance_db]
      end

    end
  end
end
