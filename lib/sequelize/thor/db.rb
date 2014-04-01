require 'sequelize'
require 'sequelize/command'
require 'sequelize/migrator'
require 'thor'

class DbBase < Thor
  class_option :environment, type: :string, aliases: '-e', default: nil

  def initialize(*)
    super
    Sequelize.setup(options[:environment]) if options[:environment]
  end
end

class Db < DbBase
  include Thor::Actions

  desc 'create', 'Create database'
  def create
    Sequelize::Command.new.create
  end

  desc 'drop', 'Drop database'
  def drop
    if yes?('Are you sure? This will erase ALL your data', :red)
      Sequelize::Command.new.drop
    end
  end

  class Migrate < DbBase

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

  class Schema < DbBase
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
    drop and create
  end

  desc 'reset', 'Nuke then migrate database'
  def reset
    nuke and Migrate.new.up
  end

end
