require 'rails_helper'

RSpec.describe Activity do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:initial_date) }
    it { is_expected.to validate_presence_of(:final_date) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:calendar).optional(true) }
    it { is_expected.to belong_to(:base_activity_type) }
    it { is_expected.to have_many(:academic_activities).dependent(:destroy) }
  end
end
