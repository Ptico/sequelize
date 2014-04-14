require 'spec_helper'
require 'sequelize/migrator/naming'

describe Sequelize::Migrator::Naming do
  subject { described_class.new(name) }

  describe 'Table' do
    context 'create' do
      let(:name) { 'create_user_profiles' }

      it { expect(subject.use_change?).to  be(true) }
      it { expect(subject.table_name).to   eql('user_profiles') }
      it { expect(subject.table_action).to eql('create_table') }
    end

    context 'drop' do
      let(:name) { 'drop_user_profiles' }

      it { expect(subject.use_change?).to  be(false) }
      it { expect(subject.table_name).to   eql('user_profiles') }
      it { expect(subject.table_action).to eql('drop_table') }
    end

    context 'rename' do
      let(:name) { 'rename_user_profiles_to_users' }

      it { expect(subject.use_change?).to  be(true) }
      it { expect(subject.table_name).to   eql('user_profiles') }
      it { expect(subject.table_rename).to eql('users') }
      it { expect(subject.table_action).to eql('rename_table') }
    end
  end

  describe 'View' do
    context 'create' do
      let(:name) { 'create_statistics_view' }

      it { expect(subject.use_change?).to  be(false) }
      it { expect(subject.table_action).to eql('create_view') }
      it { expect(subject.table_name).to   eql('statistics') }
    end

    context 'drop' do
      let(:name) { 'drop_statistics_view' }

      it { expect(subject.use_change?).to  be(false) }
      it { expect(subject.table_action).to eql('drop_view') }
      it { expect(subject.table_name).to   eql('statistics') }
    end
  end

  describe 'Attribute' do
    context 'add' do
      let(:name) { 'add_email_to_user_profiles' }

      it { expect(subject.use_change?).to   be(true) }
      it { expect(subject.table_name).to    eql('user_profiles') }
      it { expect(subject.table_action).to  eql('alter_table') }
      it { expect(subject.columns).to       contain_exactly(:email) }
      it { expect(subject.column_action).to eql('add_column') }
    end

    context 'add multiple' do
      let(:name) { 'add_email_and_name_to_user_profiles' }

      it { expect(subject.use_change?).to   be(true) }
      it { expect(subject.table_name).to    eql('user_profiles') }
      it { expect(subject.table_action).to  eql('alter_table') }
      it { expect(subject.columns).to       contain_exactly(:email, :name) }
      it { expect(subject.column_action).to eql('add_column') }
    end

    context 'remove' do
      let(:name) { 'remove_email_from_user_profiles' }

      it { expect(subject.use_change?).to   be(false) }
      it { expect(subject.table_name).to    eql('user_profiles') }
      it { expect(subject.table_action).to  eql('alter_table') }
      it { expect(subject.columns).to       contain_exactly(:email) }
      it { expect(subject.column_action).to eql('drop_column') }
    end

    context 'rename' do
      let(:name) { 'rename_full_name_to_name_of_user_profiles' }

      it { expect(subject.use_change?).to    be(true) }
      it { expect(subject.table_name).to     eql('user_profiles') }
      it { expect(subject.table_action).to   eql('alter_table') }
      it { expect(subject.column_changes).to match('full_name' => 'name') }
      it { expect(subject.column_action).to  eql('rename_column') }
    end
  end

  describe 'Index' do
    context 'create' do
      let(:name) { 'add_company_id_index_to_user_profiles' }

      it { expect(subject.use_change?).to  be(true) }
      it { expect(subject.table_name).to   eql('user_profiles') }
      it { expect(subject.table_action).to eql('alter_table') }
      it { expect(subject.index_action).to eql('create_index') }
      it { expect(subject.indexes).to      contain_exactly(:company_id) }
      it { expect(subject.columns).to      be_empty }
    end

    context 'delete' do
      let(:name) { 'remove_company_id_index_from_user_profiles' }

      it { expect(subject.use_change?).to  be(false) }
      it { expect(subject.table_name).to   eql('user_profiles') }
      it { expect(subject.table_action).to eql('alter_table') }
      it { expect(subject.index_action).to eql('drop_index') }
      it { expect(subject.indexes).to      contain_exactly(:company_id) }
      it { expect(subject.columns).to      be_empty }
    end

    context 'change' do
      let(:name) { 'change_company_id_index_in_user_profiles' }

      it { expect(subject.use_change?).to  be(false) }
      it { expect(subject.table_name).to   eql('user_profiles') }
      it { expect(subject.table_action).to eql('alter_table') }
      it { expect(subject.indexes).to      contain_exactly(:company_id) }
      it { expect(subject.columns).to      be_empty }
      it { expect(subject.index_action).to be(nil) }
    end
  end

  describe 'Other changes' do
    let(:name) { 'do_something_unusual' }

    it { expect(subject.use_change?).to be(false) }

    context 'Add many' do
      let(:name) { 'add_company_id_index_and_company_name_to_user_profiles' }

      it { expect(subject.use_change?).to  be(true) }
      it { expect(subject.table_name).to   eql('user_profiles') }
      it { expect(subject.table_action).to eql('alter_table') }
      it { expect(subject.index_action).to eql('create_index') }
      it { expect(subject.indexes).to      contain_exactly(:company_id) }
      it { expect(subject.columns).to      contain_exactly(:company_name) }

    end

    context 'Rename many' do
      let(:name) { 'rename_full_name_to_name_and_mail_to_email_of_user_profiles' }

      it { expect(subject.use_change?).to    be(true) }
      it { expect(subject.table_name).to     eql('user_profiles') }
      it { expect(subject.table_action).to   eql('alter_table') }
      it { expect(subject.column_changes).to match({ 'full_name' => 'name', 'mail' => 'email' }) }
      it { expect(subject.column_action).to  eql('rename_column') }
    end
  end

end
