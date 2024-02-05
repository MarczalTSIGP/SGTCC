require 'rails_helper'

describe 'Supervision::index', :js do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:current_orientation_tcc_one) }

  before do
    login_as(external_member, scope: :external_member)
    orientation.external_member_supervisors << external_member
    visit index_url
  end

  describe '#index' do
    let(:index_url) { external_members_supervisions_tcc_one_path }

    it 'shows basic information of tcc one supervision' do
      expect(page).to have_content(orientation.short_title)
      expect(page).to have_content(orientation.advisor.name)
      expect(page).to have_link(
        orientation.academic.name,
        href: external_members_supervision_path(orientation)
      )
    end

    it 'shows calendar information of tcc one supervision' do
      orientation.calendars.each do |calendar|
        expect(page).to have_content(calendar.year_with_semester_and_tcc)
      end
    end

    it 'shows active link for tcc one supervision' do
      expect(page).to have_selector("a[href='#{index_url}'].active")
    end

    it 'clicks on academic name and shows additional options' do
      academic_link = page.find("a[href='#{external_members_supervision_path(orientation)}']")
      academic_link.click

      expect(page).to have_link(
        'Detalhes da orientação',
        href: external_members_supervision_path(orientation)
      )
      expect(page).to have_link(
        'Atividades da orientação',
        href: external_members_supervision_calendar_activities_path(
          orientation, orientation.current_calendar
        )
      )
      expect(page).to have_link(
        'Documentos da orientação',
        href: external_members_supervision_documents_path(orientation)
      )
    end
  end
end
