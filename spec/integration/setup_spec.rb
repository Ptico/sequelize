require 'spec_helper'

describe 'Setup' do
  before :each do
    Sequelize.configure do
      root File.expand_path('../.', File.dirname(__FILE__))
    end

    Sequelize.configure :production do
      config_file 'fixtures/database.json'
    end

    Sequelize.configure :development do
      config_file 'fixtures/database.yml'
    end

    Sequelize.setup(environment)
  end

  after :each do
    Sequelize.instance_variable_set(:@config, nil)
    Sequelize.instance_variable_set(:@connection_options, nil)
    Sequelize.instance_variable_set(:@config_attributes, nil)
  end

  describe 'config' do
    subject { Sequelize.config }

    let(:environment) { 'production' }

    it { expect(subject.config_file).to eql('fixtures/database.json') }
  end

  describe 'connection options' do
    subject { Sequelize.connection_options }

    context 'when yaml file' do
      let(:environment) { 'development' }

      it 'should read configuration' do
        expect(subject.username).to eql('postgres')
        expect(subject.password).to eql('secret')
        expect(subject.database).to eql('test_db')
        expect(subject.template).to eql('mytemplate0')
      end
    end

    context 'when json file' do
      let(:environment) { 'production' }

      it 'should read configuraion' do
        expect(subject.username).to eql('ptico')
        expect(subject.password).to eql('ololo')
        expect(subject.database).to eql('testtest')
      end
    end

    context 'when ENV' do
      let(:environment) { 'staging' }

      before(:all) { ENV['DATABASE_URL'] = 'postgres://user:pass@localhost/foo' }
      after(:all)  { ENV['DATABASE_URL'] = nil}

      it 'should read configuration' do
        expect(subject.username).to eql('user')
        expect(subject.password).to eql('pass')
        expect(subject.host).to     eql('localhost')
        expect(subject.database).to eql('foo')
      end
    end
  end

end
