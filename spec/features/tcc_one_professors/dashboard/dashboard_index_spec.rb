require 'rails_helper'

describe 'Dashboard::index', :js do
  describe '#index' do
    before do
      professor = create(:professor_tcc_one)
      login_as(professor, scope: :professor)
    end

    context 'when shows the dashboard' do
      it 'shows the dashboard' do
        index_url = tcc_one_professors_root_path
        visit index_url
        expect(page).to have_css("a[href='#{index_url}'].active")
      end
    end

    context 'when professor is not authorized' do
      before do
        professor = create(:professor)
        login_as(professor, scope: :professor)
        visit tcc_one_professors_root_path
      end

      it 'redirect to the professors page' do
        expect(page).to have_current_path professors_root_path
        expect(page).to have_flash(:warning, text: not_authorized_message)
      end
    end
  end
end
