module Sequelize
  class Application < Thor::Group
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    def setup
      @db_initializer = ask('Where you want to place db initializer', :yellow, default: 'app/db.rb')
      @db_config = ask('Where you want to place db config? (Blank to manually configure)', :yellow, default: 'config/database.yml')
      @migrations_dir = ask('Choose folder for migrations', :yellow, default: 'migrations')
      @install_binaries = ask('Do you want to install dbconsole to bin/', :yellow, default: 'yes')
    end

    def set_app_root_back
      depth = @db_initializer.split('/').length - 1
      back = %w(.)
      depth.times { back << '..' }
      @app_root_back = back.join('/')
    end

    def create_thorfile
      template('templates/Thorfile.erb', 'Thorfile.thor')
    end

    def create_db_initializer
      template('templates/db.erb', @db_initializer)
    end

    def create_db_config
      unless @db_config.strip.empty?
        ext = File.extname(@db_config)
        template("templates/config#{ext}", @db_config + '.example')
        create_file('.gitignore') unless File.exist?(File.join(destination_root, '.gitignore'))
        append_to_file('.gitignore', @db_config + '.example')
      end
    end

    def create_migrations_dir
      create_file(File.join(@migrations_dir, '.gitkeep'))
    end

    def create_bin
      if @install_binaries =~ Thor::Shell::Basic.new.send(:is?, :yes)
        template('templates/dbconsole.erb', 'bin/dbconsole')
        chmod('bin/dbconsole', 0755)
      end
    end

  end
end
