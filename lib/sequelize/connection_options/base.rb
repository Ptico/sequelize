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
        config[:host] || config[:socket]
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

      def to_hash
        properties.each_with_object({}) do |prop, hash|
          value = public_send(prop)
          hash[prop] = value if value
        end
      end
      memoize :to_hash

    private

      attr_reader :config

      def initialize(config)
        @config = config
      end

      def properties
        [:database, :username, :password, :host, :port, :owner, :charset, :collation]
      end
      memoize :properties
    end

  end
end
