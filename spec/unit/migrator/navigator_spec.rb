require 'spec_helper'
require 'sequelize/migrator/navigator'

describe Sequelize::Migrator::Navigator do
  let(:instance) { described_class.new(dir, current_version) }

  let(:migrations_dir) { File.expand_path('./', 'spec/fixtures/test_migrations') }

  describe '#up' do
    subject { instance.up(to) }

    context 'when integer migrations' do
      let(:dir) { File.join(migrations_dir, 'integer') }

      context 'from scratch' do
        let(:current_version) { 0 }

        context 'to latest' do
          let(:to) { nil }

          it { expect(subject).to eql(4) }
        end

        context '1 step' do
          let(:to) { 1 }

          it { expect(subject).to eql(1) }
        end

        context 'n steps' do
          let(:to) { 2 }

          it { expect(subject).to eql(2) }
        end

        context 'to latest + 1' do
          let(:to) { 5 }

          it { expect(subject).to eql(4) }
        end
      end

      context 'from n position' do
        let(:current_version) { 1 }

        context 'to latest' do
          let(:to) { nil }

          it { expect(subject).to eql(4) }
        end

        context '1 step' do
          let(:to) { 1 }

          it { expect(subject).to eql(2) }
        end

        context 'n steps' do
          let(:to) { 2 }

          it { expect(subject).to eql(3) }
        end

        context 'to latest + 1' do
          let(:to) { 4 }

          it { expect(subject).to eql(4) }
        end
      end

    end

    context 'when timestamped migrations' do
      let(:dir) { File.join(migrations_dir, 'timestamp') }

      context 'from scratch' do
        let(:current_version) { 0 }

        context 'to latest' do
          let(:to) { nil }

          it { expect(subject).to eql(20140512) }
        end

        context '1 step' do
          let(:to) { 1 }

          it { expect(subject).to eql(20140326) }
        end

        context 'n steps' do
          let(:to) { 2 }

          it { expect(subject).to eql(20140405) }
        end

        context 'to latest + 1' do
          let(:to) { 4 }

          it { expect(subject).to eql(20140512) }
        end
      end

      context 'from n position' do
        let(:current_version) { 20140326 }

        context 'to latest' do
          let(:to) { nil }

          it { expect(subject).to eql(20140512) }
        end

        context '1 step' do
          let(:to) { 1 }

          it { expect(subject).to eql(20140405) }
        end

        context 'n steps' do
          let(:to) { 2 }

          it { expect(subject).to eql(20140510) }
        end

        context 'to latest + 1' do
          let(:to) { 4 }

          it { expect(subject).to eql(20140512) }
        end
      end
    end
  end

  describe '#down' do
    subject { instance.down(to) }

    context 'when integer migrations' do
      let(:dir) { File.join(migrations_dir, 'integer') }

      context 'from latest' do
        let(:current_version) { 4 }

        context 'to scratch' do
          let(:to) { nil }

          it { expect(subject).to eql(0) }
        end

        context '1 step' do
          let(:to) { 1 }

          it { expect(subject).to eql(3) }
        end

        context 'n steps' do
          let(:to) { 2 }

          it { expect(subject).to eql(2) }
        end

        context 'to scratch - 1' do
          let(:to) { 4 }

          it { expect(subject).to eql(0) }
        end
      end

      context 'from n position' do
        let(:current_version) { 3 }

        context 'to scratch' do
          let(:to) { nil }

          it { expect(subject).to eql(0) }
        end

        context '1 step' do
          let(:to) { 1 }

          it { expect(subject).to eql(2) }
        end

        context 'n steps' do
          let(:to) { 2 }

          it { expect(subject).to eql(1) }
        end

        context 'to scratch - 1' do
          let(:to) { 4 }

          it { expect(subject).to eql(0) }
        end
      end
    end

    context 'when timestamped migrations' do
      let(:dir) { File.join(migrations_dir, 'timestamp') }

      context 'from latest' do
        let(:current_version) { 20140512 }

        context 'to scratch' do
          let(:to) { nil }

          it { expect(subject).to eql(0) }
        end

        context '1 step' do
          let(:to) { 1 }

          it { expect(subject).to eql(20140510) }
        end

        context 'n steps' do
          let(:to) { 2 }

          it { expect(subject).to eql(20140405) }
        end

        context 'to scratch - 1' do
          let(:to) { 4 }

          it { expect(subject).to eql(0) }
        end
      end

      context 'from n position' do
        let(:current_version) { 20140510 }

        context 'to scratch' do
          let(:to) { nil }

          it { expect(subject).to eql(0) }
        end

        context '1 step' do
          let(:to) { 1 }

          it { expect(subject).to eql(20140405) }
        end

        context 'n steps' do
          let(:to) { 2 }

          it { expect(subject).to eql(20140326) }
        end

        context 'to scratch - 1' do
          let(:to) { 4 }

          it { expect(subject).to eql(0) }
        end
      end
    end
  end

end
