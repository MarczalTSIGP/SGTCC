require 'rails_helper'

describe 'Orientation::index' do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index', :js do
    context 'when shows all the orientations' do
      it 'shows basic information of history orientation' do
        orientation = create(:orientation_tcc_one, advisor: professor)
        index_url = professors_orientations_history_path
        visit index_url

        expect_orientation_index_basic_information(orientation)
        expect_active_index_link(index_url)
      end
    end
  end
end
