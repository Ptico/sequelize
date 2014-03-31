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

  class Migrate < Thor
    desc 'up', 'Perform migration up'
    def up
      migrator.migrate_up
    end

    desc 'down', 'Perform migration down'
    def down
      migrator.migrate_down
    end

    desc 'to', 'Perform migration to specified version'
    def to(version)
      migrator.migrate(version)
    end

  private

    def migrator
      Sequelize::Migrator.new
    end
  end

  desc 'rollback', 'Perform rollback'
  def rollback

  end

  desc 'nuke', 'Drop all tables'
  def nuke

  end

  desc 'reset', 'Nuke then migrate database'
  def reset

  end

  desc 'version', 'Print current schema version'
  def version
    puts Sequelize::Migrator.new.current_version
  end

private

  def db
    Sequelize.connection
  end

end
