require 'rails_helper'

describe 'Orientation::migrate' do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#migrate', :js do
    before do
      create(:orientation_tcc_one_approved)
      visit responsible_orientations_migration_path
    end

    context 'when cannot migrate' do
      it 'returns flash error message' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(
          :danger,
          text: I18n.t('flash.orientation.next_calendar_not_found')
        )
        expect(page).to have_current_path responsible_orientations_migrate_path
      end
    end

    context 'when can migrate' do
      before do
        create(:current_calendar_tcc_two)
      end

      it 'returns flash success message' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:success, text: I18n.t('flash.orientation_migrated'))
        expect(page).to have_current_path responsible_orientations_migration_path
      end
    end
  end
end
