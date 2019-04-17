require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:tcc) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:base_activity_type) }
  end
end
