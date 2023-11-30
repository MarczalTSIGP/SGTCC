require 'rails_helper'

describe 'ExaminationBoard::update', :js, type: :feature do
  let(:professor) { create(:professor_tcc_one) }
  let!(:orientation) { create(:current_orientation_tcc_one) }
  let(:resource_name) { ExaminationBoard.model_name.human }

  before do
    create(:document_type_adpp)
    login_as(professor, scope: :professor)
  end

  describe '#update' do
    let(:examination_board) { create(:current_examination_board_tcc_one) }

    before do
      visit edit_tcc_one_professors_examination_board_path(examination_board)
    end

    context 'when data is valid' do
      it 'updates the examination_board' do
        attributes = attributes_for(:examination_board)
        fill_in 'examination_board_place', with: attributes[:place]
        selectize(orientation.academic_with_calendar, from: 'examination_board_orientation_id')
        submit_form('input[name="commit"]')

        updated_path = tcc_one_professors_examination_board_path(examination_board)
        expect(page).to have_current_path updated_path
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([attributes[:place],
                                       orientation.short_title])
      end
    end

    context 'when the examination_board is not valid' do
      it 'show errors' do
        fill_in 'examination_board_place', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.examination_board_place')
      end
    end
  end

  describe '#defense_minute_update' do
    let(:examination_board) { create(:current_examination_board_tcc_one) }

    before do
      examination_board.create_defense_minutes
      visit edit_tcc_one_professors_examination_board_path(examination_board)
    end

    context 'when defense minute exists' do
      it 'hidden all the fields expect document_available_until' do
        expect(page).to have_field 'examination_board_identifier_proposal', disabled: true,
                                                                            visible: :hidden
        expect(page).to have_field 'examination_board_identifier_project', disabled: true,
                                                                           visible: :hidden

        expect(page).to have_field 'examination_board_professor_ids-selectized', disabled: true
        expect(page).to have_field 'examination_board_external_member_ids-selectized',
                                   disabled: true
        expect(page).to have_field 'examination_board_place', disabled: true

        datetime_selector = 'div#datetimepicker_examination_board_date input[disabled="disabled"]'
        expect(page).to have_css(datetime_selector)

        datetime_selector = 'div#datetimepicker_examination_board_document_available_until input'
        expect(page).to have_css(datetime_selector)

        expect(page).not_to have_css("#{datetime_selector}[disabled='disabled']")
      end
    end
  end
end
