require 'memoizable'
require 'sequel/extensions/migration'
require 'sequelize/migrator/navigator'

module Sequelize
  class Migrator
    include Memoizable

    def migrate(version=nil)
      Sequel::Migrator.run(db, migrations_dir, options.merge(target: version))
    end

    def migrate_up(step=nil)
      migrate(navigator.up(step))
    end

    def migrate_down(step=nil)
      migrate(navigator.down(step))
    end

    def current_version
      if migrated?
        record = db[migration_table].order(Sequel.desc(migration_column)).first
        record ? record[migration_column].to_i : 0
      else
        0
      end
    end

  private

    attr_reader :config, :options, :navigator

    def initialize(options={}, config=Sequelize.config)
      @config    = config
      @options   = options
      @navigator = Navigator.new(migrations_dir, current_version)
    end

    def db
      Sequelize.connection
    end

    def migrated?
      db.table_exists?(migration_table)
    end

    def migrator
      Sequel::Migrator.migrator_class(migrations_dir)
    end
    memoize :migrator

    def migration_table
      migrator::DEFAULT_SCHEMA_TABLE
    end

    def migration_column
      migrator::DEFAULT_SCHEMA_COLUMN
    end

    def migrations_dir
      dir = @config.migrations_dir || 'db/migrations'
      config.root ? File.join(config.root, dir) : dir
    end
    memoize :migrations_dir

  end
end
