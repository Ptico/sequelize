require 'spec_helper'
require 'sequelize/migrator'

describe Sequelize::Migrator do
  after(:each) do
        Sequelize.instance_variable_set(:@config, nil)
        Sequelize.instance_variable_set(:@connection_options, nil)
        Sequelize.instance_variable_set(:@config_attributes, nil)
  end
  
  let(:db) { Sequelize.connection }

  let(:migrator) {Sequelize::Migrator.new}

  context 'with version based migrations' do
      before(:each) do
        Sequelize.configure(:test) do
          connection do
            adapter 'sqlite'
            database ':memory:'
            migrations_dir File.join(File.dirname(__FILE__),'../fixtures/test_migrations/integer')
          end  
          Sequelize.setup(:test)
        end 
        Sequelize.connect!
      end

      it 'should migrate to last version' do
        migrator.migrate
        expect(Sequelize.connection.tables.sort).to eq([:schema_info, :first, :second].sort)
      end

      it 'should migrate up' do
        migrator.migrate_up
        expect(Sequelize.connection.tables).to eq([:schema_info, :first].sort)
      end

      it 'should migrate up by steps' do
        migrator.migrate_up 2
        expect(Sequelize.connection.tables.sort).to eq([:schema_info, :first, :second].sort)
      end

      it 'should migrate down' do
        migrator.migrate
        migrator.migrate_down
        expect(Sequelize.connection.tables).to eq([:schema_info, :first].sort)
      end

      it 'should migrate down by steps' do
        migrator.migrate
        migrator.migrate_down 2
        expect(Sequelize.connection.tables).to eq([])
      end
  end

  context 'with timestamp based migrations' do
    before(:each) do
        Sequelize.configure(:test) do
          connection do
            adapter 'sqlite'
            database ':memory:'
            migrations_dir File.join(File.dirname(__FILE__),'../fixtures/test_migrations/timestamp')
          end  
          Sequelize.setup(:test)
        end 
      end

      it 'should migrate to last version' do
        migrator.migrate
        expect(Sequelize.connection.tables.sort).to eq([:schema_migrations, :first, :second].sort)
      end

      it 'should migrate up' do
        migrator.migrate_up
        expect(Sequelize.connection.tables).to eq([:schema_migrations, :first].sort)
      end

      it 'should migrate up by steps' do
        migrator.migrate_up 2
        expect(Sequelize.connection.tables.sort).to eq([:schema_migrations, :first, :second].sort)
      end

      it 'should migrate down' do
        migrator.migrate
        migrator.migrate_down
        expect(Sequelize.connection.tables).to eq([:schema_migrations, :first].sort)
      end

      it 'should migrate down by steps' do
        migrator.migrate
        migrator.migrate_down 2
        expect(Sequelize.connection.tables).to eq([])
      end
  end
end