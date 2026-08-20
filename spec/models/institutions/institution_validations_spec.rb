require 'rails_helper'

RSpec.describe Institution do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:trade_name) }
    it { is_expected.to validate_presence_of(:cnpj) }
    it { is_expected.to validate_uniqueness_of(:cnpj).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:external_member) }
    it { is_expected.to have_many(:orientations).dependent(:restrict_with_error) }
  end
end
