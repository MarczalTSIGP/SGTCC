require 'rails_helper'

RSpec.describe SiteHelper do
  describe '#activity_status_class' do
    let(:activity) { create(:activity) }

    it 'expired' do
      activity.final_date = 1.day.ago
      expect(helper.activity_status_class(activity)).to eql('text-decoration-line-through')
    end

    it 'ontime' do
      activity.final_date = Time.zone.now
      expect(helper.activity_status_class(activity)).to eql('font-weight-bold')
    end
  end
end
