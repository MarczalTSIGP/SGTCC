require 'rails_helper'

RSpec.describe ExaminationBoard do
  describe 'callbacks' do
    it 'enqueues Notifications::CreateJob after create' do
      expect do
        create(:examination_board)
      end.to have_enqueued_job(Notifications::CreateJob)
        .with(hash_including(notification_type: 'atendees_examination_board_assigned'))
    end
  end
end
