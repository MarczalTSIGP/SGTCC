require 'rails_helper'

describe 'Orientation::to_migrate', type: :feature do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#to_migrate', js: true do
    let!(:orientations) { create_list(:orientation_tcc_one_approved, 2) }
    let(:index_url) { responsible_orientations_migration_path }

    before do
      visit index_url
    end

    it 'shows all orientations that need to be migrated' do
      orientations.each do |orientation|
        expect(page).to have_content(orientation.academic.name)
      end
    end

    it 'display buttons to migrate orientations' do
      buttons = page.all('input[type=submit]')
      expect(buttons.size).to eq(orientations.size)
      expect(buttons.first.value).to eq(I18n.t('views.buttons.migrate'))
    end

    it 'does not show orientations already migrated' do
      next_calendar = create(:next_calendar_tcc_two)
      expect(page).not_to have_content(next_calendar.year_with_semester_and_tcc)
    end
  end
end
