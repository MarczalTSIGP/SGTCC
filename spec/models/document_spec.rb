require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:document_type) }
  end
end
