require 'rails_helper'

describe 'Calendar::index', type: :feature, js: true do
  let(:external_member) { create(:external_member) }
  let!(:orientation) { create(:orientation) }

  before do
    login_as(external_member, scope: :external_member)
    orientation.external_member_supervisors << external_member
  end

  describe '#index' do
    context 'when shows all calendars' do
      it 'shows all tcc 1 calendars with options' do
        visit external_members_calendars_path

        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester)
          expect(page).to have_content(I18n.t("enums.tcc.#{calendar.tcc}"))
          expect(page).to have_content(orientation.title)
          expect(page).to have_content(short_date(calendar.created_at))

          orientation.supervisors.each do |supervisor|
            expect(page).to have_content(supervisor.name)
          end
        end

        expect(page).to have_selector("a[href='#{external_members_calendars_path}'].active")
      end
    end
  end
end
