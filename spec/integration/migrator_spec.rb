require 'spec_helper'
require 'sequelize/migrator'

describe Sequelize::Migrator do
  after(:each) do
        Sequelize.instance_variable_set(:@config, nil)
        Sequelize.instance_variable_set(:@connection_options, nil)
        Sequelize.instance_variable_set(:@config_attributes, nil)
  end
  
  let(:db) { Sequelize.connect! }

  let(:migrator) { Sequelize::Migrator.new}

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
      end

      it 'should migrate to last version' do
        migrator.migrate
        expect(db.tables.sort).to eq(['first', 'second'])
      end

      it 'should migrate up' do
        migrator.migrate_up
        expect(db.tables).to eq(['first'])
        migrator.migrate_up
        expect(db.tables.sort).to eq(['first', 'second'])
      end

      it 'should migrate up by steps' do
        migrator.migrate_up 2
        expect(db.tables.sort).to eq(['first', 'second'])
      end

      it 'should migrate down' do
        migrator.migrate
        migrator.migrate_down
        expect(db.tables).to eq(['first'])
      end

      it 'should migrate down by steps' do
        migrator.migrate
        migrator.migrate_down 2
        expect(db.tables).to eq([])
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
        expect(db.tables.sort).to eq(['first', 'second'])
      end

      it 'should migrate up' do
        migrator.migrate_up
        expect(db.tables).to eq(['first'])
        migrator.migrate_up
        expect(db.tables.sort).to eq(['first', 'second'])
      end

      it 'should migrate up by steps' do
        migrator.migrate_up 2
        expect(db.tables.sort).to eq(['first', 'second'])
      end

      it 'should migrate down' do
        migrator.migrate
        migrator.migrate_down
        expect(db.tables).to eq(['first'])
      end

      it 'should migrate down by steps' do
        migrator.migrate
        migrator.migrate_down 2
        expect(db.tables).to eq([])
      end
  end
end