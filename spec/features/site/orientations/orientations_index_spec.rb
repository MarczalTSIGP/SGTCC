require 'rails_helper'

describe 'Orientation::index', :js do
  describe '#index' do
    before do
      create(:page, url: 'tccs-aprovados')
      create(:page, url: 'tccs-aprovados-em-tcc-um')
      create(:page, url: 'tccs-em-tcc-um')
    end

    context 'when shows all the approved orientations' do
      let!(:orientation) { create(:orientation_tcc_two_approved) }
      let(:index_url) { site_approved_orientations_path }

      before do
        visit index_url
      end

      it 'shows all the approved orientations' do
        expect(page).to have_contents([orientation.document_title,
                                       orientation.advisor.name,
                                       orientation.academic.name])

        expect(page).to have_css("a[href='#{index_url}'].active")
        expect(page).to have_selector(link(orientation.final_monograph.pdf.url))
        expect(page).to have_selector(link(orientation.final_monograph.complementary_files.url))
      end
    end

    context 'when shows all approved in tcc one orientations' do
      let!(:orientation) { create(:orientation_tcc_one_approved) }
      let(:index_url) { site_approved_tcc_one_orientations_path }

      before do
        visit index_url
      end

      it 'shows all the in progress orientations' do
        expect(page).to have_contents([orientation.document_title,
                                       orientation.advisor.name,
                                       orientation.academic.name])

        expect(page).to have_css("a[href='#{index_url}'].active")
        expect(page).to have_selector(link(orientation.final_project.pdf.url))
      end
    end
  end
end
