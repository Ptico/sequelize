require 'sequel'
require 'sequelize/command'
require 'sequelize/migrator'
require 'thor'

class Db < Thor
  class_option :environment, type: :string, aliases: '-e', default: 'development'

  desc 'create', 'Create database'
  def create
    Sequelize::Command.new.create
  end

  desc 'drop', 'Drop database'
  def drop
    Sequelize::Command.new.drop
  end

  desc 'dump FILE', 'Dump database to FILE'

  class Migrate < Thor
    desc 'up [STEPS]', 'Perform migration up (default: to latest version)'
    def up(steps=nil)
      migrator.migrate_up(steps)
    end

    desc 'down [STEPS]', 'Perform migration down (default: 1 step), 0 for full rollback'
    def down(steps=1)
      migrator.migrate_down(steps)
    end

    desc 'to VERSION', 'Perform migration to specified version'
    def to(version)
      migrator.migrate(version)
    end

  private

    def migrator
      Sequelize::Migrator.new
    end
  end

  class Schema < Thor
    desc 'version', 'Print current schema version'
    def version
      puts Sequelize::Migrator.new.current_version
    end

    desc 'dump FILE', 'Dump schema to file'
    def dump(file)
      Sequelize::Command.new.dump_schema(file)
    end

    desc 'load FILE', 'Load schema from file'
    def load(file)
      Db.new.create
      Sequelize::Command.new.load(file)
    end
  end

  desc 'dump FILE', 'Dump database to file'
  def dump(file)
    Sequelize::Command.new.dump(file)
  end

  desc 'load FILE', 'Load database from file'
  def load(file)
    create
    Sequelize::Command.new.load(file)
  end

  desc 'nuke', 'Drop all data and reset schema'
  def nuke
    drop
    create
  end

  desc 'reset', 'Nuke then migrate database'
  def reset
    nuke
    Migrate.new.up
  end

private

  def db
    Sequelize.connection
  end

end
