require 'rails_helper'

# Caracterização da regra "reunião só muda antes de o acadêmico visualizar" (REF-28).
RSpec.describe 'Authorization: professor meetings' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:alert) { ->(action) { I18n.t("flash.orientation.meeting.errors.#{action}") } }

  before { login_as(professor, scope: :professor) }

  context 'when the meeting was not viewed' do
    let!(:meeting) { create(:meeting, orientation:, viewed: false) }

    it 'allows editing' do
      get edit_professors_meeting_path(meeting)
      expect(response).to have_http_status(:ok)
    end

    it 'allows destroying' do
      expect { delete professors_meeting_path(meeting) }.to change(Meeting, :count).by(-1)
    end
  end

  context 'when the meeting was viewed' do
    let!(:meeting) { create(:meeting, orientation:, viewed: true) }

    it 'blocks editing' do
      get edit_professors_meeting_path(meeting)
      expect(response).to redirect_to(professors_meetings_path)
      expect(flash[:alert]).to eq(alert.call('edit'))
    end

    it 'blocks destroying' do
      expect { delete professors_meeting_path(meeting) }.not_to change(Meeting, :count)
      expect(response).to redirect_to(professors_meetings_path)
      expect(flash[:alert]).to eq(alert.call('destroy'))
    end

    it 'blocks updating' do
      patch professors_meeting_path(meeting), params: { meeting: { content: 'alterado' } }
      expect(meeting.reload.content).not_to eq('alterado')
      expect(response).to redirect_to(professors_meetings_path)
      expect(flash[:alert]).to eq(alert.call('edit'))
    end
  end
end
