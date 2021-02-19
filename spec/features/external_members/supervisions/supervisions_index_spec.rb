require 'rails_helper'

describe 'Supervision::index', type: :feature, js: true do
  let(:external_member) { create(:external_member) }

  before do
    login_as(external_member, scope: :external_member)
  end

  describe '#index' do
    context 'when shows all the supervisions of tcc one calendar' do
      it 'shows all the supervisions of tcc one with options' do
        orientation = create(:current_orientation_tcc_one)
        orientation.external_member_supervisors << external_member

        index_url = external_members_supervisions_tcc_one_path
        visit index_url

        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_content(orientation.academic.name)

        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when shows all the supervisions of tcc two calendar' do
      it 'shows all the supervisions of tcc two with options' do
        orientation = create(:current_orientation_tcc_two)
        orientation.external_member_supervisors << external_member

        index_url = external_members_supervisions_tcc_two_path
        visit index_url

        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_content(orientation.academic.name)

        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
