require 'rails_helper'

RSpec.describe ExternalMember do
  subject(:em) { build(:external_member) }

  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:working_area) }

    it { is_expected.to validate_length_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    context 'when email is valid' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
    end

    context 'when email is not valid' do
      it { is_expected.not_to allow_value('foo').for(:email) }
    end

    context 'when personal page is valid' do
      it { is_expected.to allow_value('http://personalpage.com.br').for(:personal_page) }
    end

    context 'when personal page is not valid' do
      it { is_expected.not_to allow_value('personalpage.com').for(:personal_page) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:scholarity) }
    it { is_expected.to have_many(:institutions).dependent(:restrict_with_error) }

    it do
      ems_fk = 'external_member_supervisor_id'
      expect(em).to have_many(:external_member_supervisors).with_foreign_key(ems_fk)
    end

    it { is_expected.to have_many(:supervisions).through(:external_member_supervisors) }
    it { is_expected.to have_many(:all_documents).through(:supervisions) }
    it { is_expected.to have_many(:examination_board_attendees) }
    it { is_expected.to have_many(:examination_boards).through(:examination_board_attendees) }
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = described_class.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(described_class.human_genders).to eq(hash)
    end
  end

  describe '#name_with_scholarity' do
    let(:external_member) { create(:external_member) }

    it 'is equal name with scholarity' do
      name_with_scholarity = "#{external_member.scholarity.abbr} #{external_member.name}"
      expect(external_member.name_with_scholarity).to eq(name_with_scholarity)
    end
  end
end
