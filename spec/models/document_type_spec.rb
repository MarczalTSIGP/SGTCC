require 'rails_helper'

RSpec.describe DocumentType, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:documents).dependent(:destroy) }
  end
end
