module Sequelize
  class Migrator
    class Navigator

      def version
        @versions[@current]
      end

      def up
        @current += 1 if @current < @versions.size-1
      end

      def down
        @current -=1 if @current > 0
      end

      def set(new_version)
        @current = @versions.find_index(new_version)
      end

    private

      def initialize(dir)
        @current  = 0
        @versions = [@current] + get_versions(dir)
      end

      def get_versions(dir)
        pattern = dir+'/*.rb'
        entries = Dir.glob(pattern)

        versions = entries.map do |item| 
          name = File.basename(item)
          name.split('_')[0].to_i 
        end
        
        versions.sort
      end

    end
  end
end