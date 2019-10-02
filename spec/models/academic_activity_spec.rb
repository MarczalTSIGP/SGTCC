require 'rails_helper'

RSpec.describe AcademicActivity, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:summary) }
    it { is_expected.to validate_presence_of(:pdf) }
  end
end
