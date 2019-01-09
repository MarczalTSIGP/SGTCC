require 'rails_helper'

RSpec.describe Academic, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:ra) }
    it { is_expected.to validate_presence_of(:gender) }

    context 'email' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
      it { is_expected.to_not allow_value('foo').for(:email) }
    end
  end
end
