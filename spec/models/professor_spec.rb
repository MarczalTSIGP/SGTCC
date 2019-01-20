require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:email) }
    it { is_expected.to validate_length_of(:password) }

    context 'with email' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
      it { is_expected.not_to allow_value('foo').for(:email) }
    end
  end
end
