require 'thor'

require 'sequelize/migrator/naming'
require 'sequelize/migrator/migration_attributes'

module Generate
  class Model < Thor::Group
  end

  class Migration < Thor::Group
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    argument :name, type: :string
    argument :attributes, type: :array, default: [], banner: 'field:type field:type'

    def create_migration
      @naming = Sequelize::Migrator::Naming.new(name)
      @attrs  = Sequelize::Migrator::MigrationAttributes.new(attributes, @naming)

      action = @naming.use_change? ? 'change' : 'updown'

      template(
        "templates/migration/#{action}.erb",
        File.join(Sequelize.config.migrations_dir, "#{name}.rb")
      )
    end

  end
end
