require 'sequelize/migrator'
require 'sequelize/migrator/migration_attributes'

describe Sequelize::Migrator::MigrationAttributes do
  let(:instance) { described_class.new(params) }
  let(:params) { { name: name, args: args } }
  let(:attributes) { instance.attributes.map { |x| x.to_h } }
  let(:indexes) { instance.indexes.map { |x| x.to_h } }

  describe '#attributes' do 
    context 'when attributes from naming' do

      context 'with indexes' do
        let(:name) { 'add_company_id_index_and_company_name_to_user_profiles' }
        let(:args) { [] }
 
        it { expect(attributes).to match_array([{ name: :company_name, type: nil, options: {} }]) }
        it { expect(indexes).to match_array([{ name: :company_id, options:  nil }]) }
      end

      context 'with types' do
        let(:name) { 'add_email_and_age_to_user_profiles' }

        context 'without options' do
          let(:args) { ['string', 'integer'] }

          it { expect(attributes).to match_array([{ name: :email, type: 'String', options: {} }, { name: :age, type: 'Fixnum', options: {} }])}
        end

        context 'with options' do
          let(:args) { ['string(10)', 'integer'] }

          it { expect(attributes).to match_array([{ name: :email, type: 'String', options: { size: 10 } }, { name: :age, type: 'Fixnum', options: {} }]) }
        end
      end

      context 'without types' do
        let(:name) { 'add_email_and_age_to_user_profiles' }
        let(:args) { [] }

        it { expect(attributes).to match_array([{ name: :email, type: nil, options: {}}, { name: :age, type: nil, options: {}}])}
      end

      context 'with additional attributes from task' do
        let(:name) { 'add_age_to_user_profiles' }
        let(:args) { ['integer'] }

        it 'should add attribute to the list of attributes' do
          instance.add_attribute(:email, 'String', { size: 10 })

          expect(attributes).to match_array([{ name: :age, type: 'Fixnum', options: {} }, { name: :email, type: 'String', options: { size: 10 } }])
        end

        it 'should add index to the list of indexes' do
          instance.add_index(:user_id)
          expect(indexes).to match_array([{ name: :user_id, options: {} }])
        end
      end
    end
  
    context 'when attributes from args' do
      let(:name) { 'create_users' }

      context 'with indexes' do
        let(:args) { ['name:text', 'age:integer:index'] }

        it { expect(attributes).to match_array([{ name: :name, type: 'String', options: {} }, {name: :age, type: 'Fixnum', options: {} }]) }
        it { expect(indexes).to match_array([{ name: :age, options:  {} }]) }
      end

      context 'with types' do
        let(:args) { ['name:text', 'age:integer'] }

        it { expect(attributes).to match_array([{ name: :name, type: 'String', options: {} }, {name: :age, type: 'Fixnum', options: {} }]) }
      end

      context 'without types' do
        let(:args) { ['name', 'age'] }

        it { expect(attributes).to match_array([{ name: :name, type: nil, options: {} }, {name: :age, type: nil, options: {} }]) }
      end

      context 'with additional attributes from task' do
        let(:args) { ['name:text', 'age:integer'] }

        it 'should add additional attributes' do
          instance.add_attribute(:email, 'String', { size: 10 })

          expect(attributes).to match_array([{ name: :email, type: 'String', options: { size: 10 } }, { name: :age, type: 'Fixnum', options: {} }, { name: :name, type: 'String', options: {} }])
        end
      end
    end
  end

  describe '.normalize_type' do
    let(:normalized) { described_class.normalize_type(type) }
    context 'numeric conversion' do
      context 'when int given' do
        let(:type) { 'integer' }
        it { expect(normalized).to eql('Fixnum') }
      end

      context 'when bigint given' do
        let(:type) { 'bigint' }
        it { expect(normalized).to eql('Bignum') }
      end 

      context 'when double given' do
        let(:type) { 'double' }
        it { expect(normalized).to eql('Float') }
      end

      context 'when float given' do
        let(:type) { 'float' }
        it { expect(normalized).to eql('Float') }
      end

      context 'when numeric given' do
        let(:type) { 'numeric' }
        it { expect(normalized).to eql('BigDecimal') }
      end

      context 'when numeric with options' do
        let(:type) { 'numeric(10)' }
        it { expect(normalized).to eql('BigDecimal') }
      end
    end

    context 'datetime conversion' do
      context 'when date given' do
        let(:type) { 'date' }
        it { expect(normalized).to eql('Date') }
      end

      context 'when timestamp given' do
        let(:type) { 'timestamp' }
        it { expect(normalized).to eql('DateTime') }
      end

      context 'when time given' do
        let(:type) { 'time' }
        it { expect(normalized).to eql('Time') }
      end
    end
    context 'string conversion' do
      context 'when full string given' do
        let(:type) { 'string(255)' }
        it { expect(normalized).to eql('String') }
      end

      context 'when string given' do
        let(:type) { 'string(50)' }
        it { expect(normalized).to eql('String') }
      end

      context 'when char given' do
        let(:type) { 'char(50)' }
        it { expect(normalized).to eql('String') }
      end

      context 'when full char given' do
        let(:type) { 'char(255)' }
        it { expect(normalized).to eql('String') }
      end
    end

    context 'text conversion' do
      context 'when text given' do
        let(:type) { 'text' }
        it { expect(normalized).to eql('String') }
      end
    end

    context 'boolean conversion' do
      context 'when bool given' do
        let(:type) { 'bool' }
        it { expect(normalized).to eql('TrueClass') }
      end

      context 'when boolean given' do
        let(:type) { 'boolean' }
        it { expect(normalized).to eql('TrueClass') }
      end
    end
      # primary key?
  end

  describe '.extract_options' do
      context 'type options without name' do
        let(:options) { attributes.first[:options] }
        let(:name) { 'add_something_to_user_profiles' }

        context 'when sized string given' do
          let(:args) { ['string(50)']}
          it { expect(options).to eql({ size: 50 }) }
        end

        context 'when fixed string given' do
          let(:args) { ['string(40):fixed'] }
          it { expect(options).to eql({ fixed: true, size: 40 }) }
        end

        context 'when char given' do
          let(:args) { ['char(255)'] }
          it { expect(options).to eql({ fixed: true }) }
        end

        context 'when sized char given' do
          let(:args) { ['char(50)'] }
          it { expect(options).to eql({ fixed: true, size: 50 }) }
        end

        context 'when sized numeric given' do
          let(:args) { ['numeric(40)'] }
          it { expect(options).to eql({ size: 40 }) }
        end

        context 'when time given' do
          let(:args) { ['time'] }
          it { expect(options).to eql({ only_time: true }) }
        end
      end

      context 'with name' do
        context 'attributes from args' do
          let(:name) { 'create_users' }
          let(:args) { [ 'age:integer:index', 'name:char(50):fixed' ] }

          it 'should has age index' do
            expect(indexes).to match_array([{ name: :age, options: {} }])
          end

          it 'should has attributes with right properties' do
            expect(attributes).to match_array([{ name: :age, type: 'Fixnum', options: {} }, { name: :name, type: 'String', options: { size: 50, fixed: true } }])
          end
        end
      end

  end
end
