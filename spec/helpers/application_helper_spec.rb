require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    context 'when not receives any param' do
      it 'show title' do
        expect(helper.full_title).to eql('SGTCC')
      end
    end

    context 'when receives param' do
      it 'show {param} | title' do
        expect(helper.full_title('Home')).to eql('Home | SGTCC')
      end
    end
  end
end
