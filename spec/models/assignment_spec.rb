require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'associations' do
    subject { create(:assignment) }

    it { is_expected.to belong_to(:role) }
    it { is_expected.to belong_to(:professor) }

    it { is_expected.to validate_uniqueness_of(:professor).scoped_to(:role_id) }
  end
end
