require 'rails_helper'

describe 'Orientation::report', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Professor.model_name.human }

  before do
    create_list(:orientation, 2)
    create_list(:orientation_renewed, 2)
    create_list(:orientation_canceled, 3)
    create_list(:orientation_approved, 1)
    login_as(responsible, scope: :professor)
    visit responsible_root_path
  end

  describe '#reports' do
    context 'when is tcc one' do
      let(:tcc_one_url) { responsible_orientations_tcc_one_path }

      let(:tcc_one_renewed_url) do
        responsible_orientations_search_tcc_one_path(status: 'RENEWED')
      end

      let(:tcc_one_approved_url) do
        responsible_orientations_search_tcc_one_path(status: 'APPROVED')
      end

      let(:tcc_one_canceled_url) do
        responsible_orientations_search_tcc_one_path(status: 'CANCELED')
      end

      it 'returns the orientations in progress total component' do
        total = Orientation.tcc_one('IN_PROGRESS').count
        expect(page).to have_contents([total,
                                       orientations_in_progress_label])
        expect(page).to have_selector(link(tcc_one_url))
      end

      it 'returns the orientations renewed total component' do
        total = Orientation.tcc_one('RENEWED').count / 2
        expect(page).to have_contents([total,
                                       orientations_renewed_label])
        expect(page).to have_selector(link(tcc_one_renewed_url))
      end

      it 'returns the orientations approved total component' do
        total = Orientation.tcc_one('APPROVED').count
        expect(page).to have_contents([total,
                                       orientations_approved_label])
        expect(page).to have_selector(link(tcc_one_approved_url))
      end

      it 'returns the orientations canceled total component' do
        total = Orientation.tcc_one('CANCELED').count
        expect(page).to have_contents([total,
                                       orientations_canceled_label])
        expect(page).to have_selector(link(tcc_one_canceled_url))
      end
    end
  end
end
