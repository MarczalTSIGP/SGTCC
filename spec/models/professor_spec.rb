require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:lattes) }
    it { is_expected.to validate_presence_of(:gender) }

    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_length_of(:email) }
    it { is_expected.to validate_length_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

    context 'when email is valid' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
    end

    context 'when email is not valid' do
      it { is_expected.not_to allow_value('foo').for(:email) }
    end

    context 'when lattes is valid' do
      it { is_expected.to allow_value('http://lattes.com/link').for(:lattes) }
    end

    context 'when lattes is not valid' do
      it { is_expected.not_to allow_value('lattes.com').for(:lattes) }
    end
  end
end
