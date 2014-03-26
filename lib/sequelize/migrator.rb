require 'memoizable'
require 'sequel/extensions/migration'

module Sequelize
  class Migrator
    include Memoizable

    def migrate(version=nil)
      @navigator.last unless version

      version ||= @navigator.version

      opts = options.merge(target: version)

      Sequel::Migrator.run(db, migrations_dir, opts)
    end

    def migrate_up(step=nil)
      @navigator.up step
      migrate(@navigator.version)
    end

    def migrate_down(step=nil)
      @navigator.down step
      migrate(@navigator.version)
    end

    def current_version
      version = 0

      version = db[migration_table].map(migration_column).first if db.table_exists? migration_table

      version
    end

  private

    attr_reader :config, :options

    def initialize(options={}, config=Sequelize.config)
      @config    = config
      @options   = options
      @navigator = Navigator.new(migrations_dir)

      @navigator.set(current_version)
    end

    def migrator
      Sequel::Migrator.migrator_class(migrations_dir)
    end

    def migration_table
      migrator::DEFAULT_SCHEMA_TABLE
    end
    memoize :migration_table

    def migration_column
      migrator::DEFAULT_SCHEMA_COLUMN
    end
    memoize :migration_column

    def migrations_dir
      dir = @config.connection.migrations_dir || 'db/migrations'
      config.root ? File.join(config.root, dir) : dir
    end
    memoize :migrations_dir

    def db
      Sequelize.connection
    end
  end
end
