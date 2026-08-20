require 'rails_helper'

describe 'Orientation::update' do
  let(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation) }
  let!(:academic) { create(:academic) }
  let!(:advisor) { create(:professor) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit edit_responsible_orientation_path(orientation)
  end

  describe '#update', :js do
    context 'when data is valid' do
      it 'updates the orientation' do
        attributes = attributes_for(:orientation)
        fill_in 'orientation_title', with: attributes[:title]
        slim_select(academic.name, from: 'orientation_academic_id')
        slim_select(advisor.name, from: 'orientation_advisor_id')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_orientation_path(orientation)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([attributes[:title],
                                       academic.name,
                                       advisor.name])
      end
    end

    context 'when the orientation is not valid' do
      it 'show errors' do
        fill_in 'orientation_title', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.orientation_title')
      end
    end

    context 'when the orientation cant be edited' do
      let(:orientation) { create(:orientation) }

      before do
        create(:document_type_adpp)
        eb = create(:examination_board, :proposal, orientation:)
        eb.create_defense_minutes
        visit edit_responsible_orientation_path(orientation)
      end

      it 'redirect to the orientations page' do
        expect(page).to have_current_path responsible_orientations_tcc_one_path
        expect(page).to have_flash(:warning, text: orientation_edit_signed_warning_message)
      end
    end
  end
end
