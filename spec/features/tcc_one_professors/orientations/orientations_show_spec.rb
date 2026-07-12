require 'rails_helper'

describe 'Orientation::show' do
  let(:professor) { create(:professor_tcc_one) }
  let!(:orientation) { create(:orientation, :current, :tcc_one) }

  before do
    login_as(professor, scope: :professor)
    visit tcc_one_professors_calendar_orientation_path(orientation.current_calendar, orientation)
  end

  describe '#show' do
    it 'shows the current orientation by tcc one' do
      expect_orientation_show_basic_information(orientation)
    end
  end
end
