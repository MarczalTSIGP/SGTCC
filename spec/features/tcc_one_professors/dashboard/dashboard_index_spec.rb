require 'rails_helper'

describe 'Dashboard::index', type: :feature, js: true do
  describe '#index' do
    before do
      professor = create(:professor_tcc_one)
      login_as(professor, scope: :professor)
    end

    context 'when shows the dashboard' do
      it 'shows the dashboard' do
        index_url = tcc_one_professors_root_path
        visit index_url
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
