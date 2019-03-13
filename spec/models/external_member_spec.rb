require 'rails_helper'

RSpec.describe ExternalMember, type: :model do
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
  end

  describe '#human_genders' do
    it 'returns the genders' do
      genders = ExternalMember.genders
      hash = {}
      genders.each_key { |key| hash[I18n.t("enums.genders.#{key}")] = key }

      expect(ExternalMember.human_genders).to eq(hash)
    end
  end
end
