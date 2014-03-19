module Sequelize
  class ConnectionOptions
    class Base
      include Adamantium

      def database
        config[:database] || config[:dbname]
      end
      memoize :database

      def username
        config[:username] || config[:user] || ''
      end
      memoize :username

      def password
        config[:password] || config[:pass] || ''
      end
      memoize :password

      def host
        config[:host] || config[:path] || config[:socket]
      end
      memoize :host

      def port
        config[:port].to_i if config[:port]
      end
      memoize :port

      def owner
        config[:owner]
      end
      memoize :owner

      def charset
        config[:charset] || config[:encoding] || 'utf8'
      end
      memoize :charset

      def collation
        config[:collation]
      end
      memoize :collation

    private

      attr_reader :config

      def initialize(options)
        @config = options.each_with_object({}) do |pair, conf|
          conf[pair.first.to_sym] = pair.last
        end
      end
    end

  end
end
