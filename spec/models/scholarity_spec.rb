require 'rails_helper'

RSpec.describe Scholarity, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:abbr) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:professors).dependent(:destroy) }
    it { is_expected.to have_many(:external_members).dependent(:destroy) }
  end
end
