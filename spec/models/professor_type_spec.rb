require 'rails_helper'

RSpec.describe ProfessorType, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:professors).dependent(:destroy) }
  end
end
