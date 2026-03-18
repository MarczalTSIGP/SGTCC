require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:activities).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:academic_activities).through(:activities) }
    it { is_expected.to have_many(:orientation_calendars).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:orientations).through(:orientation_calendars) }
  end
end
