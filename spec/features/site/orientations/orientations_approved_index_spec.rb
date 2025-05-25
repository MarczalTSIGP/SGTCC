require 'rails_helper'

describe 'Orientation::index', :js do
  describe '#index' do
    before do
      create(:page, url: 'tccs-aprovados')
    end

    context 'when showing all the approved orientations' do
      let(:index_url) { site_approved_orientations_path }

      it 'shows complementary files' do
        orientation = create(:orientation_tcc_two_approved)
        visit index_url

        expect(page).to have_css("a[href='#{index_url}'].active")

        within("#orientation_#{orientation.id}") do
          expect(page).to have_content(orientation.document_title)
          expect(page).to have_content(orientation.advisor.name)
          expect(page).to have_content(orientation.academic.name)

          expect(page).to have_selector(link(orientation.final_monograph.pdf.url))
          expect(page).to have_selector(link(orientation.final_monograph.complementary_files.url))
        end
      end

      it 'not shows complementary files' do
        orientation = create(:orientation_tcc_two_approved_no_complementary_files)
        visit index_url

        expect(page).to have_css("a[href='#{index_url}'].active")

        within("#orientation_#{orientation.id}") do
          expect(page).to have_content(orientation.document_title)
          expect(page).to have_content(orientation.advisor.name)
          expect(page).to have_content(orientation.academic.name)

          expect(page).to have_selector(link(orientation.final_monograph.pdf.url))
          expect(page).to have_no_css('a', text: 'Arquivos complementares')
        end
      end
    end
  end
end
