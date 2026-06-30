require 'rails_helper'

RSpec.describe Academic do
  describe 'methods to ldap' do
    let!(:academic) { create(:academic) }

    it 'find by ra without a' do
      expect(academic).to eql(described_class.find_through_ra(academic.ra))
    end

    it 'find by ra with a' do
      expect(academic).to eql(described_class.find_through_ra("a#{academic.ra}"))
    end
  end
end
