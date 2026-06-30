require 'rails_helper'

RSpec.describe Signature do
  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to belong_to(:document) }
  end
end
