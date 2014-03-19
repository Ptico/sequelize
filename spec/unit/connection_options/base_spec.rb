require 'spec_helper'

describe Sequelize::ConnectionOptions::Base do
  let(:instance) { described_class.new(options) }

  it_behaves_like 'connection options'
end
