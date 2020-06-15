require 'rails_helper'

describe 'Activity::document', type: :feature, js: true do
  let(:academic) { create(:academic) }
  let!(:activity) { create(:activity) }
  let(:calendar) { activity.calendar }
  let(:show_url) { academics_calendar_activity_path(calendar, activity) }
  let(:resource_name) { Activity.model_name.human }

  before do
    login_as(academic, scope: :academic)
  end

  describe '#upload document / create' do
    before do
      visit show_url
    end

    context 'when uploads is valid' do
      it 'uploads the document' do
        attributes = attributes_for(:academic_activity)

        fill_in 'academic_activity_title', with: attributes[:title]
        fill_in 'academic_activity_summary', with: attributes[:summary]

        expect(page).to have_css('.custom-file-input', visible: false)
        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'academic_activity_pdf', FileSpecHelper.pdf.path
        attach_file 'academic_activity_complementary_files', FileSpecHelper.zip.path

        submit_form('input[name="commit"]')

        expect(page).to have_current_path show_url
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(find('#academic_activity_title').value).to eq attributes[:title]
        expect(find('#academic_activity_summary').value).to eq attributes[:summary]
      end
    end

    context 'when uploads is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.academic_activity_title')
        expect(page).to have_message(blank_error_message, in: 'div.academic_activity_summary')
        expect(page).to have_message(blank_error_message, in: 'div.academic_activity_pdf')
      end
    end
  end

  describe '#upload document / update' do
    before do
      create(:academic_activity, activity: activity, academic: academic)
      visit show_url
    end

    context 'when data is valid' do
      it 'updates the document' do
        attributes = attributes_for(:academic_activity)

        fill_in 'academic_activity_title', with: attributes[:title]
        fill_in 'academic_activity_summary', with: attributes[:summary]

        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'academic_activity_pdf', FileSpecHelper.pdf.path
        attach_file 'academic_activity_complementary_files', FileSpecHelper.zip.path

        submit_form('input[name="commit"]')

        expect(page).to have_current_path show_url
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(find('#academic_activity_title').value).to eq attributes[:title]
        expect(find('#academic_activity_summary').value).to eq attributes[:summary]
      end
    end

    context 'when the upload is not valid' do
      it 'show errors' do
        fill_in 'academic_activity_title', with: ''
        fill_in 'academic_activity_summary', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.academic_activity_title')
        expect(page).to have_message(blank_error_message, in: 'div.academic_activity_summary')
      end
    end
  end
end
