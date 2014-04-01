require 'shellwords'

module Sequelize
  class Command
    class Base

    private

      attr_reader :options

      def initialize(options=Sequelize.connection_options)
        @options = options
      end

      def build(command, &block)
        @command = [command.to_s]

        yield

        Shellwords.join(@command)
      end

      def run(command, &block)
        execute(build(command, &block))
      end

      def run_and_quit(command, &block)
        Kernel.exec(build(command, &block))
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
end
