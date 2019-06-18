require 'rails_helper'

describe 'Orientation::update', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation) }
  let!(:academic) { create(:academic) }
  let!(:advisor) { create(:professor) }
  let!(:calendar) { create(:calendar) }
  let!(:professors) { create_list(:professor, 4) }
  let!(:external_members) { create_list(:external_member, 4) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit edit_responsible_orientation_path(orientation)
  end

  describe '#update', js: true do
    context 'when data is valid' do
      it 'updates the orientation' do
        attributes = attributes_for(:orientation)
        fill_in 'orientation_title', with: attributes[:title]
        supervisor = professors.first
        external_member_supervisor = external_members.last
        selectize(calendar.year_with_semester_and_tcc, from: 'orientation_calendar_id')
        selectize(academic.name, from: 'orientation_academic_id')
        selectize(advisor.name, from: 'orientation_advisor_id')
        selectize(external_member_supervisor.name,
                  from: 'orientation_external_member_supervisor_ids')
        selectize(supervisor.name,
                  from: 'orientation_professor_supervisor_ids')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_orientation_path(orientation)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([attributes[:title],
                                       calendar.year_with_semester_and_tcc,
                                       academic.name,
                                       advisor.name,
                                       supervisor.name,
                                       external_member_supervisor.name])
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
      before do
        create(:signature_signed, orientation_id: orientation.id)
        visit edit_responsible_orientation_path(orientation)
      end

      it 'redirect to the orientations page' do
        expect(page).to have_current_path responsible_orientations_tcc_one_path
        expect(page).to have_flash(:warning, text: orientation_edit_signed_warning_message)
      end
    end
  end
end
