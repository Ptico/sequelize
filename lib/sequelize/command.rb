require 'shellwords'

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
    end
  private

    def initialize(options=Sequelize.connection_options)
      @options = options
    end

    def build(command, &block)
      @command = [command.to_s]

      yield

      @command.join(' ')
    end

    def run(command, &block)
      execute(build(command, &block))
    end

    def option(key, value)
      if value
        separator = key[0, 2] == '--' ? '=' : ' '
        @command << "#{key}#{separator}#{value}"
      end
    end

    def flag(flag)
      @command << flag
    end

    def execute(command)
      `#{command}`
    end
  end
end
