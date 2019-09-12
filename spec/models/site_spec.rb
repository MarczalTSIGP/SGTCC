require 'rails_helper'

RSpec.describe Site, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
  end
end
