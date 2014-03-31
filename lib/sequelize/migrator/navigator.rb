module Sequelize
  class Migrator
    class Navigator
      include Memoizable

      attr_reader :migration_dir, :current_version, :current_index

      def up(step=nil)
        versions[up_index(step)]
      end

      def down(step=nil)
        versions[down_index(step)]
      end

      def versions
        Dir.glob(File.join(migration_dir, '*.rb')).map do |item|
          File.basename(item).split('_').first.to_i
        end.sort.unshift(0)
      end
      memoize :versions

    private

      attr_reader :max

      def initialize(migration_dir, current_version)
        @migration_dir   = migration_dir
        @current_version = current_version
        @current_index   = versions.index(current_version)
        @max             = versions.length - 1
      end

      def up_index(step)
        index = step.nil? ? -1 : (current_index + step.to_i)
        index > max ? max : index
      end

      def down_index(step)
        index = step.nil? ? 0 : (current_index - step.to_i)
        index < 0 ? 0 : index
      end

    end
  end
end
