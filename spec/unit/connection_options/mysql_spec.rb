require 'spec_helper'

require 'sequelize/connection_options/adapters/mysql'

describe Sequelize::ConnectionOptions::Mysql do
  let(:instance) { described_class.new(options) }

  it_behaves_like 'connection options'

  describe '#collation' do
    subject { instance.collation }

    context 'when not specified' do
      let(:options) { {} }

      it { expect(subject).to eql('utf8_unicode_ci') }
    end
  end

  describe '#to_hash' do
    subject { instance.to_hash }

    let(:options) { { pass: 'bar' } }

    it { expect(subject).to include(collation: 'utf8_unicode_ci') }
  end

end
