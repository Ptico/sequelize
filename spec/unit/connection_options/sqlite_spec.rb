require 'spec_helper'

require 'sequelize/connection_options/adapters/sqlite'

describe Sequelize::ConnectionOptions::Sqlite do
  let(:instance) { described_class.new(options) }

  it_behaves_like 'connection options'

  describe '#database' do
    subject { instance.database }

    context 'when `path`' do
      let(:options) { { path: '/tmp/db.sock' } }

      it { expect(subject).to eql('/tmp/db.sock') }
    end
  end

end
