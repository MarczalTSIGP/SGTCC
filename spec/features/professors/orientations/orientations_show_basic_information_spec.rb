require 'rails_helper'

describe 'Orientation::show' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:calendar_tcc_one) { create(:calendar, :current, :tcc_one) }
  let(:calendar_tcc_two) { create(:calendar, :current, :tcc_two) }
  let(:orientation_tcc_one) do
    create(:orientation, advisor: professor,
                         calendars: [calendar_tcc_one])
  end
  let(:orientation_tcc_two) do
    create(:orientation, advisor: professor,
                         calendars: [calendar_tcc_two])
  end

  before do
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when shows the orientation' do
      it 'shows the orientation' do
        visit professors_orientation_path(orientation)

        expect_orientation_show_basic_information(orientation)

        first("a[href='#{professors_orientations_history_path}']", text: 'Histórico').click
        expect(page).to have_current_path professors_orientations_history_path
      end
    end
  end
end
