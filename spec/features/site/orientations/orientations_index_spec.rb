require 'rails_helper'

describe 'Orientation::index', type: :feature do
  describe '#index', js: true do
    before do
      create(:page, url: 'tccs-em-andamento')
      create(:page, url: 'tccs-aprovados')
    end

    context 'when shows all the approved orientations' do
      let!(:orientation) { create(:orientation_tcc_two_approved) }
      let(:academic) { orientation.academic }
      let(:activity) { create(:monograph_activity, final_version: true) }

      let!(:academic_activity) do
        create(:academic_activity, academic: academic, activity: activity)
      end

      let(:index_url) { site_approved_orientations_path }

      before do
        visit index_url
      end

      it 'shows all the approved orientations' do
        expect(page).to have_contents([orientation.title,
                                       orientation.advisor.name,
                                       orientation.academic.name])

        expect(page).to have_selector("a[href='#{index_url}'].active")
        expect(page).to have_selectors([link(academic_activity.pdf.url),
                                        link(academic_activity.complementary_files.url)])
      end
    end

    context 'when shows all the in progress orientations' do
      let!(:orientation) { create(:orientation_tcc_one) }
      let(:academic) { orientation.academic }
      let(:activity) { create(:proposal_activity, final_version: true) }

      let!(:academic_activity) do
        create(:academic_activity, academic: academic, activity: activity)
      end

      let(:index_url) { site_in_progress_orientations_path }

      before do
        visit index_url
      end

      it 'shows all the in progress orientations' do
        expect(page).to have_contents([orientation.short_title,
                                       orientation.advisor.name,
                                       orientation.academic.name])

        expect(page).to have_selector("a[href='#{index_url}'].active")
        expect(page).to have_selector(link(academic_activity.pdf.url))
      end
    end
  end
end
