require 'sequelize/connection_options/base'

module Sequelize
  class ConnectionOptions
    class << self
      def register(name, klass)
        @registry ||= {}
        @registry[name] = klass
      end

      def [](adapter)
        require "sequelize/connection_options/adapters/#{adapter}"
        @registry[adapter.to_sym]
      end
    end
  end
end

require 'sequelize/connection_options/reader'
