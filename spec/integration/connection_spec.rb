require 'spec_helper'
require 'sequelize/command'
require 'sequelize/command/adapters/postgres'

describe 'connection' do
  describe 'sqlite' do

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
