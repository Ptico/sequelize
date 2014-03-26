require 'spec_helper'
require 'sequelize/migrator'

describe Sequelize::Migrator do
  after(:each) do
        Sequelize.instance_variable_set(:@config, nil)
        Sequelize.instance_variable_set(:@connection_options, nil)
        Sequelize.instance_variable_set(:@config_attributes, nil)
        Sequelize.instance_variable_set(:@connection, nil)
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
        expect(Sequelize.connection[:schema_info].map(:version)).to eq([2])
      end

      it 'should migrate up' do
        migrator.migrate_up
        expect(Sequelize.connection[:schema_info].map(:version)).to eq([1])
      end

      it 'should migrate up by steps' do
        migrator.migrate_up 2
        expect(Sequelize.connection[:schema_info].map(:version)).to eq([2])
      end

      it 'should migrate down' do
        migrator.migrate
        migrator.migrate_down
        expect(Sequelize.connection[:schema_info].map(:version)).to eq([1])
      end

      it 'should migrate down by steps' do
        migrator.migrate
        migrator.migrate_down 2
        expect(Sequelize.connection[:schema_info].map(:version)).to eq([0])
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
        expect(Sequelize.connection[:schema_migrations].map(:filename).last).to eq('20140405_create_second_table.rb')
      end

      it 'should migrate up' do
        migrator.migrate_up
        expect(Sequelize.connection[:schema_migrations].map(:filename).last).to eq('20140326_create_first_table.rb')
      end

      it 'should migrate up by steps' do
        migrator.migrate_up 2
        expect(Sequelize.connection[:schema_migrations].map(:filename).last).to eq('20140405_create_second_table.rb')
      end

      it 'should migrate down' do
        migrator.migrate
        migrator.migrate_down
        expect(Sequelize.connection[:schema_migrations].map(:filename).last).to eq('20140326_create_first_table.rb')
      end

      it 'should migrate down by steps' do
        migrator.migrate
        migrator.migrate_down 2
        expect(Sequelize.connection[:schema_migrations].map(:filename)).to eq([])
      end
  end
end