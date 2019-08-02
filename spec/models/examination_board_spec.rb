require 'rails_helper'

RSpec.describe ExaminationBoard, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:place) }
    it { is_expected.to validate_presence_of(:date) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
  end
end
