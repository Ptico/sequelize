require 'pry'
module Sequelize
  class ConnectionOptions
    class Base
      include Adamantium
      
      def self.property(name)
        memoize name
        @properties = [] unless @properties
        @properties << name
      end

      def adapter
        config[:adapter]
      end
      property :adapter

      def database
        config[:database] || config[:dbname]
      end
      property :database

      def username
        config[:username] || config[:user] || ''
      end
      property :username

      def password
        config[:password] || config[:pass] || ''
      end
      property :password

      def host
        config[:host] || config[:socket]
      end
      property :host

      def port
        config[:port].to_i if config[:port]
      end
      property :port

      def owner
        config[:owner]
      end
      property :owner

      def charset
        config[:charset] || config[:encoding] || 'utf8'
      end
      property :charset

      def collation
        config[:collation]
      end
      property :collation

      def servers
        config[:servers]
      end
      property :servers

      def single_threaded
        config[:single_threaded]
      end
      property :single_threaded

      def test
        config[:test]
      end
      property :test

      def max_connections
        config[:max_connections]
      end
      property :max_connections

      def pool_sleep_time
        config[:pool_sleep_time]
      end
      property :pool_sleep_time

      def pool_timeout
        config[:pool_timeout]
      end
      property :pool_timeout

      def to_hash
        properties = (self.class.instance_variable_get(:@properties) || [])
        parent_properties = self.class.superclass.instance_variable_get(:@properties)
        
        properties += parent_properties if parent_properties

        properties.each_with_object({}) do |prop, hash|
          value = public_send(prop)
          hash[prop] = value if value
        end
      end
      memoize :to_hash

    private

      attr_reader :config

      def initialize(config)
        @config   = config
      end
    end
  end
end
