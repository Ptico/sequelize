require 'memoizable'

module Sequelize
  class Migrator
    include Memoizable

    def migrate(version=nil)
      opts = version ? options.merge(version: version) : options

      Sequel::Migrator.run(Sequelize.connection, migrations_dir, options)
    end

    def migrate_up(step=nil)
      version = step ? get_version(step, :+) : nil
      migrate(version)
    end

    def migrate_down(step=nil)
      migrate(step ? get_version(step, :-) : 0)
    end

    def current_version
      Sequelize.connection[:schema_migrations].first[:version]
    end
    memoize :current_version

  private

    attr_reader :config, :options

    def initialize(options={}, config=Sequelize.config)
      @config  = config
      @options = options
    end

    def get_version(step, dir)
      i = versions.at(current_version)
      versions[i.public_send(dir, step)]
    end

    def migrations_dir
      dir = config.migrations_dir || 'db/migrations'
      config.root ? File.join(config.root, dir) : dir
    end
    memoize :migrations_dir

    def versions
      Dir[File.join(migrations_dir, '*.rb')].map do |file|
        File.basename(file).split(Sequel::Migrator::MIGRATION_SPLITTER).first
      end.sort
    end
    memoize :versions

  end
end
