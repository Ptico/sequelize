require 'spec_helper'

describe Sequelize::ConnectionOptions do
  describe '.[]' do
    let(:adapter) { described_class[:postgres] }

    it 'should load adapter' do
      expect(adapter.ancestors).to include(described_class::Base)
    end
  end
end
