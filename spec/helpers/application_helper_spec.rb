require 'rails_helper'

RSpec.describe ApplicationHelper do
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

  describe '#icon_to_activity' do
    context 'when activity is send document' do
      it 'return the icon' do
        activity = create(:activity)
        expect(helper.icon_to_activity(activity)).to eql('<i class="fas fa-file-upload pr-2"></i>')
      end
    end

    context 'when the activity is info' do
      it 'return the icon' do
        activity = create(:activity, base_activity_type: create(:base_activity_type_info))
        expect(helper.icon_to_activity(activity)).to eql('<i class="fas fa-info pr-3"></i>')
      end
    end
  end
end
