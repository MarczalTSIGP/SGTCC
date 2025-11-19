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
        orientation = Orientation.last
        submit_form('input[name="commit"]')

        # Verifica que a orientação ainda está na lista (não foi migrada)
        expect(page).to have_content(orientation.short_title)
        expect(page).to have_current_path(%r{orientations/migration})
      end
    end
  end
end