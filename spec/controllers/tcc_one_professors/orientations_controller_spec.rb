require 'rails_helper'

describe 'TccOneProfessorsOrientationsController', type: :request do
  let(:professor) { create(:professor_tcc_one) }
  let(:orientation) { create(:orientation, :current, :tcc_one) }
  let(:calendar) { orientation.current_calendar }

  before { login_as(professor, scope: :professor) }

  describe '#by_calendar' do
    it 'lists the orientations of the calendar' do
      get tcc_one_professors_calendar_orientations_path(calendar)

      expect(response.body).to include(orientation.short_title)
    end

    # Regressão: o controller passava params[:status] no lugar de params[:page],
    # então a paginação da tela não saía nunca da primeira página.
    it 'honours the page parameter' do
      get tcc_one_professors_calendar_orientations_path(calendar, page: 2)

      expect(response.body).not_to include(orientation.short_title)
    end

    it 'filters by status' do
      approved = create(:orientation, :approved_tcc_one, calendars: [calendar])

      get tcc_one_professors_calendar_orientations_path(
        calendar, status: Orientation.statuses.key('APPROVED_TCC_ONE')
      )

      expect(response.body).to include(approved.short_title)
      expect(response.body).not_to include(orientation.short_title)
    end
  end
end
