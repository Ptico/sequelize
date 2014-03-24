require 'spec_helper'

require 'sequelize/connection_options/adapters/postgres'

describe Sequelize::ConnectionOptions::Postgres do
  let(:instance) { described_class.new(options) }

  it_behaves_like 'connection options'

  describe '#encoding' do
    subject { instance.encoding }

    context 'when `encoding`' do
      let(:options) { { encoding: 'big5' } }

      it { expect(subject).to eql('big5') }
    end

    context 'when charset' do
      let(:options) { { charset: 'big5' } }

      it { expect(subject).to eql('big5') }
    end

    context 'when not set' do
      let(:options) { {} }

      it { expect(subject).to eql('utf8') }
    end
  end

  describe '#locale' do
    subject { instance.locale }

    context 'when set' do
      let(:options) { { locale: 'ru_RU.UTF-8' } }

      it { expect(subject).to eql('ru_RU.UTF-8') }
    end
  end

  describe '#ctype' do
    subject { instance.ctype }

    context 'when set' do
      let(:options) { { ctype: 'ru_RU.UTF-8' } }

      it { expect(subject).to eql('ru_RU.UTF-8') }
    end
  end

  describe '#template' do
    subject { instance.template }

    context 'when set' do
      let(:options) { { template: 'template0' } }

      it { expect(subject).to eql('template0') }
    end
  end

  describe '#tablespace' do
    subject { instance.tablespace }

    context 'when set' do
      let(:options) { { tablespace: 'myspace' } }

      it { expect(subject).to eql('myspace') }
    end
  end

  describe '#maintenance_db' do
    subject { instance.maintenance_db }

    context 'when set' do
      let(:options) { { maintenance_db: 'pg_maintenance' } }

      it { expect(subject).to eql('pg_maintenance') }
    end
  end

  describe '#to_hash' do
    subject { instance.to_hash }

    let(:options) { { template: 'mytemplate' } }

    it { expect(subject).to include(template: 'mytemplate') }
  end

end
