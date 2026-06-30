require 'rails_helper'

RSpec.describe Document do
  describe 'associations' do
    it { is_expected.to belong_to(:document_type).without_validating_presence }
    it { is_expected.to have_many(:signatures).dependent(:destroy) }
  end
end
