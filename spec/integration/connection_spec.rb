require 'spec_helper'
require 'sequelize/command'
require 'sequelize/command/adapters/postgres'
require 'sequelize/command/adapters/sqlite'

describe 'connection' do
  describe Sequelize::Command::Sqlite do
    let(:config) { Sequelize.config.connection }

    context 'when db is not in memory' do

      let(:db_path){ "#{config.root}/../tmp/test.sqlite"}

      before(:all) do
        FileUtils.mkdir("#{File.dirname(__FILE__)}/../tmp")

        Sequelize.configure(:development) do
          connection do
            root     File.dirname(__FILE__)
            adapter  'sqlite'
            database 'test.sqlite'
          end
          Sequelize.setup(:development)
        end 
      end

      after(:all) do
        Sequelize.instance_variable_set(:@config, nil)
        Sequelize.instance_variable_set(:@connection_options, nil)
        Sequelize.instance_variable_set(:@config_attributes, nil)

        FileUtils.rm_r("#{File.dirname(__FILE__)}/../tmp") 
      end

      subject { described_class.new }

      describe '#create' do
        it 'should create it via Sequel' do
          expect(::Sequel).to receive(:connect).with(adapter: 'sqlite3', database: db_path)
          subject.create
        end
      end

      describe '#drop' do
        it 'should delete db file' do
          expect(File.exist?(db_path)).to eq(true)
          subject.drop
          expect(File.exist?(db_path)).to eq(false)
        end
      end

      describe '#dump' do
        let(:dump_file) { 'dump.sql' }

        it 'should use sqlite3 command' do
          expect(subject).to receive(:`).with(
            "sqlite3 #{db_path} .schema > #{dump_file}"
          )
          subject.dump dump_file
        end
      end

      describe '#load' do
        let(:dump_file) { 'dump.sql' }

        it 'should use sqlite3 command' do
          expect(subject).to receive(:`).with(
            "sqlite3 #{db_path} < #{dump_file}"
          )
          subject.load dump_file
        end
      end
    end

    context 'when db in memory' do
      before do
        Sequelize.configure(:development) do
          connection do
            adapter  'sqlite'
            database ':memory:'
          end
        end   
      end

      describe '#create' do
        it "don't do anything" do
          expect(::Sequel).to_not receive(:connect)
          subject.create
        end
      end

    end     
  end

  describe Sequelize::Command::Postgres, postgresql: true do

    let(:config) { Sequelize.config.connection }

    before do
      Sequelize.configure(:development) do
        connection do
          adapter        'postgres' 
          database       'testtest' 
          encoding       'utf-8' 
          locale         'ru_RU.UTF-8' 
          username       'postgres' 
          password       'ololo' 
          host           'localhost' 
          port           5432
          owner          'base_owner'
          maintenance_db 'somedb'
          template       'template0'
          collation      'somecollation'
          ctype          'ctype0'
          tablespace     'spaaace'
        end
      end

      Sequelize.setup(:development)
    end

    after(:all) do
      Sequelize.instance_variable_set(:@config, nil)
      Sequelize.instance_variable_set(:@connection_options, nil)
      Sequelize.instance_variable_set(:@config_attributes, nil)
    end

    subject { described_class.new }



    describe '#create' do
      it 'should exec createdb' do
        expect(subject).to receive(:`).with(
         "createdb --username=#{config.username} --host=#{config.host} --port=#{config.port} --maintenance-db=#{config.maintenance_db} --encoding=#{config.encoding} --locale=#{config.locale} --lc-collate=#{config.collation} --lc-ctype=#{config.ctype} --template=#{config.template} --tablespace=#{config.tablespace} --owner=#{config.owner} #{config.database}"
        )
        subject.create
      end
    end

    describe '#drop' do
      it 'should exec dropdb' do
        expect(subject).to receive(:`).with(
          "dropdb --username=#{config.username} --host=#{config.host} --port=#{config.port} #{config.database}"
        )
        subject.drop
      end
    end

    describe '#dump' do
      let(:dump_file) { 'dump.sql' }

      it 'should exec pg_dump' do
        expect(subject).to receive(:`).with(
          "pg_dump --username=#{config.username} --host=#{config.host} --port=#{config.port} -i -s -x -O --file=#{dump_file} #{config.database}"
        )
        subject.dump dump_file
      end
    end
    
    describe '#load' do
      let(:dump_file) { 'dump.sql' }

      it 'should exec psql' do
        expect(subject).to receive(:`).with(
          "psql --username=#{config.username} --host=#{config.host} --port=#{config.port} --file=#{dump_file} #{config.database}"
        )
        subject.load dump_file
      end
    end
 
  end

  describe 'mysql', mysql: true do

  end

end
