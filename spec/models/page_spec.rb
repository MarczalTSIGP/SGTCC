require 'rails_helper'

RSpec.describe Page, type: :model do
  describe 'validates' do
    subject { create(:page) }

    before do
      create(:site)
    end

    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url).case_insensitive }
    it { is_expected.to validate_presence_of(:menu_title) }
    it { is_expected.to validate_uniqueness_of(:menu_title).case_insensitive }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:fa_icon) }
  end
end
