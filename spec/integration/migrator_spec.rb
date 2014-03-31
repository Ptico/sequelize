require 'spec_helper'
require 'sequelize/migrator'

describe Sequelize::Migrator do
  before(:each) do
    dir = File.join(File.dirname(__FILE__), '../fixtures/test_migrations', migrations_dir)

    Sequelize.configure(:test) do
      connection do
        adapter  'sqlite'
        database ':memory:'
        migrations_dir dir
      end

      Sequelize.setup(:test)
    end

    Sequelize.connect!
  end

  after(:each) do
    Sequelize.instance_variable_set(:@config, nil)
    Sequelize.instance_variable_set(:@connection_options, nil)
    Sequelize.instance_variable_set(:@config_attributes, nil)
    Sequelize.instance_variable_set(:@connection, nil)
  end

  let(:db)       { Sequelize.connection }
  let(:migrator) { Sequelize::Migrator.new }

  describe 'integer migrations' do
    subject { db[:schema_info].first[:version] }

    let(:migrations_dir) { 'integer' }

    context 'from scratch' do
      it 'should migrate to last version' do
        migrator.migrate
        expect(subject).to eq(4)
        expect(db.table_exists?(:fourth)).to be_truthy
      end

      it 'should migrate up to latest version' do
        migrator.migrate_up
        expect(subject).to eq(4)
        expect(db.table_exists?(:fourth)).to be_truthy
      end

      it 'should migrate up to n steps' do
        migrator.migrate_up(2)
        expect(subject).to eq(2)
        expect(db.table_exists?(:fourth)).to be_falsy
        expect(db.table_exists?(:second)).to be_truthy
      end
    end

    context 'from already migrated' do
      before(:each) do
        described_class.new.migrate(2)
      end

      it 'should migrate to last version' do
        migrator.migrate
        expect(subject).to eq(4)
        expect(db.table_exists?(:fourth)).to be_truthy
      end

      it 'should migrate up to latest version' do
        migrator.migrate_up
        expect(subject).to eq(4)
        expect(db.table_exists?(:fourth)).to be_truthy
      end

      it 'should migrate up to n steps' do
        migrator.migrate_up(1)
        expect(subject).to eq(3)
        expect(db.table_exists?(:fourth)).to be_falsy
        expect(db.table_exists?(:third)).to be_truthy
      end

      it 'should migrate down to scratch' do
        migrator.migrate_down
        expect(subject).to eql(0)
        expect(db.table_exists?(:first)).to be_falsy
        expect(db.table_exists?(:second)).to be_falsy
      end

      it 'should migrate down to n steps' do
        migrator.migrate_down(1)
        expect(subject).to eql(1)
        expect(db.table_exists?(:first)).to be_truthy
        expect(db.table_exists?(:second)).to be_falsy
      end
    end
  end

  describe 'timestamp migrations' do
    let(:migrations_dir) { 'timestamp' }

    context 'from scratch' do
      it 'should migrate to last version' do
        migrator.migrate

        [:first, :second, :third, :fourth].each do |table|
          expect(db.table_exists?(table)).to be_truthy
        end
      end

      it 'should migrate up to latest version' do
        migrator.migrate_up

        [:first, :second, :third, :fourth].each do |table|
          expect(db.table_exists?(table)).to be_truthy
        end
      end

      it 'should migrate up to n steps' do
        migrator.migrate_up(2)

        expect(db.table_exists?(:second)).to be_truthy
        expect(db.table_exists?(:third)).to  be_falsy
      end
    end

    context 'from already migrated' do
      before(:each) do
        described_class.new.migrate(20140405)
      end

      it 'should migrate to last version' do
        migrator.migrate

        [:first, :second, :third, :fourth].each do |table|
          expect(db.table_exists?(table)).to be_truthy
        end
      end

      it 'should migrate up to latest version' do
        migrator.migrate_up

        [:first, :second, :third, :fourth].each do |table|
          expect(db.table_exists?(table)).to be_truthy
        end
      end

      it 'should migrate up to n steps' do
        migrator.migrate_up(1)

        expect(db.table_exists?(:fourth)).to be_falsy
        expect(db.table_exists?(:third)).to be_truthy
      end

      it 'should migrate down to scratch' do
        migrator.migrate_down

        [:first, :second, :third, :fourth].each do |table|
          expect(db.table_exists?(table)).to be_falsy
        end
      end

      it 'should migrate down to n steps' do
        migrator.migrate_down(1)

        expect(db.table_exists?(:first)).to be_truthy
        expect(db.table_exists?(:second)).to be_falsy
      end
    end
  end
end
