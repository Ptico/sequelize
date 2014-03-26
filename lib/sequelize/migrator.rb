require 'memoizable'
require 'sequel/extensions/migration'
# INFO
# Sequel::Migrator creates a table 
# (schema_info for integer migrations 
# and schema_migrations for timestamped migrations). 
# in the database to keep track of the current migration version.

module Sequelize
  class Migrator
    include Memoizable

    def migrate(version=nil)
      @navigator.last unless version

      version ||= @navigator.version

      opts = options.merge(target: version)

      Sequel::Migrator.run(Sequelize.connection, migrations_dir, options)
    end

    def migrate_up(step=nil)
      @navigator.up
      (step - 1).times { @navigator.up } if step
      migrate(@navigator.version)
    end

    def migrate_down(step=nil)
      @navigator.down
      (step - 1).times { @navigator.down } if step
      migrate(@navigator.version)
    end

    def current_version
      version = 0
      db = Sequelize.connection
      version = db[:schema_migrations].first[:version] if db.tables.include? 'schema_migrations'
      version = db[:schema_info].first[:version] if db.tables.include? 'schema_info'
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

    def migrations_dir
      dir = @config.connection.migrations_dir || 'db/migrations'
      config.root ? File.join(config.root, dir) : dir
    end
    memoize :migrations_dir

  end
end
