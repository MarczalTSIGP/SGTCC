require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:role) }
    it { is_expected.to belong_to(:professor) }
  end
end
