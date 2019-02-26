require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full title' do
    it 'defaulf' do
      expect(helper.full_title).to eql('SGTCC')
    end

    it 'title' do
      expect(helper.full_title('Home')).to eql('Home | SGTCC')
    end
  end
end
