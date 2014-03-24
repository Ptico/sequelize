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

  desc 'migrate', 'Perform migration'
  method_option :version, type: :numeric, aliases: '-v', banner: 'Migrate to specified version'
  def migrate

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

  end

private

  def db
    Sequelize.connection
  end

end
