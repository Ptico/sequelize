shared_examples_for 'connection options' do

  describe '#initialize' do
    let(:options) { { 'database' => 'foo' } }

    it { expect(instance.database).to eql('foo') }
  end

  describe '#database' do
    subject { instance.database }

    context 'when `database`' do
      let(:options) { { database: 'mydb' } }

      it { expect(subject).to eql('mydb') }
    end

    context 'when `dbname`' do
      let(:options) { { dbname: 'mydb' } }

      it { expect(subject).to eql('mydb') }
    end
  end

  describe '#password' do
    subject { instance.password }

    context 'when `password`' do
      let(:options) { { password: 'secret' } }

      it { expect(subject).to eql('secret') }
    end

    context 'when `pass`' do
      let(:options) { { pass: 'secret' } }

      it { expect(subject).to eql('secret') }
    end
  end

  describe '#username' do
    subject { instance.username }

    context 'when `username`' do
      let(:options) { { username: 'ptico' } }

      it { expect(subject).to eql('ptico') }
    end

    context 'when `user`' do
      let(:options) { { user: 'ptico' } }

      it { expect(subject).to eql('ptico') }
    end
  end

  describe '#host' do
    subject { instance.host }

    context 'when `host`' do
      let(:options) { { host: 'localhost' } }

      it { expect(subject).to eql('localhost') }
    end

    context 'when `path`' do
      let(:options) { { path: '/tmp/db.sock' } }

      it { expect(subject).to eql('/tmp/db.sock') }
    end

    context 'when `socket`' do
      let(:options) { { socket: '/tmp/db.sock' } }

      it { expect(subject).to eql('/tmp/db.sock') }
    end

    context 'when not specified' do
      let(:options) { {} }

      it { expect(subject).to be_nil }
    end
  end

  describe '#port' do
    subject { instance.port }

    context 'when integer' do
      let(:options) { { port: 1234 } }

      it { expect(subject).to eql(1234) }
    end

    context 'when string' do
      let(:options) { { port: '1234' } }

      it { expect(subject).to eql(1234) }
    end

    context 'when not specified' do
      let(:options) { {} }

      it { expect(subject).to be_nil }
    end
  end

  describe 'owner' do
    subject { instance.owner }

    context 'when specified' do
      let(:options) { { owner: 'ptico' } }

      it { expect(subject).to eql('ptico') }
    end

    context 'when not specified' do
      let(:options) { {} }

      it { expect(subject).to be_nil }
    end
  end

  describe '#charset' do
    subject { instance.charset }

    context 'when `charset`' do
      let(:options) { { charset: 'cp1251' } }

      it { expect(subject).to eql('cp1251') }
    end

    context 'when `encoding`' do
      let(:options) { { encoding: 'cp1252' } }

      it { expect(subject).to eql('cp1252') }
    end

    context 'when not specified' do
      let(:options) { {} }

      it { expect(subject).to eql('utf8') }
    end
  end

  describe '#collation' do
    subject { instance.collation }

    context 'when specified' do
      let(:options) { { collation: 'en_US.UTF-8' } }

      it { expect(subject).to eql('en_US.UTF-8') }
    end
  end

end
