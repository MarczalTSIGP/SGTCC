require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:fa_icon) }
  end
end
