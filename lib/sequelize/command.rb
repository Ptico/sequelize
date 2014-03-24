require 'sequelize/command/base'

module Sequelize
  class Command
    class << self
      def register(name, klass)
        @registry ||= {}
        @registry[name] = klass
      end

      def [](adapter)
        require "sequelize/command/adapters/#{adapter}"
        @registry[adapter.to_sym]
      end

      def new(options=Sequelize.connection_options)
        self[options.adapter].new
      end
    end

  end
end
