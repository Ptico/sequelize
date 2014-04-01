shared_examples_for 'connection options' do

  describe '#to_hash' do
    subject { instance.to_hash }

    let(:options) { { user: 'foo', pass: 'bar' } }

    it { expect(subject).to include(username: 'foo', password: 'bar') }
  end

  describe '#adapter' do
    subject { instance.adapter }

    let(:options) { { adapter: 'do:postgres' } }

    it { expect(subject).to eql('do:postgres') }
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

  describe '#servers' do
    subject { instance.servers }

    context 'when specified' do
      let(:options) { { servers: { master: 'config' } } }

      it { expect(subject).to eql({ master: 'config' }) }
    end
  end

  describe '#single_threaded' do
    subject { instance.single_threaded }

    context 'when specified' do
      let(:options) { { single_threaded: true } }

      it { expect(subject).to eql(true) }
    end
  end

  describe '#test' do
    subject { instance.test }

    context 'when specified' do
      let(:options) { { test: true } }

      it { expect(subject).to eql(true) }
    end
  end

  describe '#max_connections' do
    subject { instance.max_connections }

    context 'when specified' do
      let(:options) { { max_connections: 8 } }

      it { expect(subject).to eql(8) }
    end
  end

  describe '#pool_sleep_time' do
    subject { instance.pool_sleep_time }

    context 'when specified' do
      let(:options) { { pool_sleep_time: 1 } }

      it { expect(subject).to eql(1) }
    end
  end

  describe '#pool_timeout' do
    subject { instance.pool_timeout }

    context 'when specified' do
      let(:options) { { pool_timeout: 5 } }

      it { expect(subject).to eql(5) }
    end
  end

end
