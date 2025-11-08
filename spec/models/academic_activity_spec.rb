require 'rails_helper'

RSpec.describe AcademicActivity do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:summary) }
    it { is_expected.to validate_presence_of(:pdf) }
  end

  describe '#update_judgment' do
    let(:academic_activity) { create(:academic_activity) }

    it 'returns true' do
      expect(academic_activity.update_judgment).to be(true)
    end
  end

  describe 'callbacks' do
    let(:activity) { create(:academic_activity) }

    it 'enqueues Notifications::CreateJob after create' do
      expect do
        activity
      end.to have_enqueued_job(Notifications::CreateJob)
        .with(hash_including(notification_type: 'document_uploaded'))
    end

    it 'enqueues Notifications::CreateJob after update' do
      activity

      expect do
        activity.update(title: 'Novo Titulo')
      end.to have_enqueued_job(Notifications::CreateJob)
        .with(hash_including(notification_type: 'document_updated'))
    end
  end
end
