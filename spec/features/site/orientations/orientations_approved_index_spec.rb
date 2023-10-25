require 'rails_helper'

describe 'Orientation::index', type: :feature, js: true do
  describe '#index' do
    before do
      create(:page, url: 'tccs-aprovados')
    end

    context 'when showing all the approved orientations' do
      let!(:orientation) { create(:orientation_tcc_two_approved) }
      let!(:orientation_without_complementary) do
        create(:orientation_tcc_two_approved_without_complementary_files)
      end
      let(:index_url) { site_approved_orientations_path }

      before do
        visit index_url
      end

      it 'shows all the approved orientations with complementary files' do
        expect(page).to have_contents([orientation.document_title,
                                       orientation.advisor.name,
                                       orientation.academic.name])

        expect(page).to have_selector("a[href='#{index_url}'].active")
        expect(page).to have_selector(link(orientation.final_monograph.pdf.url))
        expect(page).to have_selector(link(orientation.final_monograph.complementary_files.url))

        url = orientation_without_complementary.final_monograph.complementary_files.url

        expect(page).not_to have_selector(link(url))
      end
    end
  end
end
