require 'rails_helper'

describe 'Activity::document', :js do
  let(:academic) { create(:academic) }
  let!(:activity) { create(:activity) }
  let(:calendar) { activity.calendar }
  let(:show_url) { academics_calendar_activity_path(calendar, activity) }

  before do
    login_as(academic, scope: :academic)
  end

  def flash_message(key)
    I18n.t("flash.actions.#{key}", resource_name: Activity.model_name.human)
  end

  describe '#upload document / create' do
    before { visit show_url }

    context 'when uploads are valid' do
      it 'uploads the document' do
        attributes = attributes_for(:academic_activity)

        fill_in 'academic_activity_title', with: attributes[:title]
        fill_in 'academic_activity_summary', with: attributes[:summary]

        attach_file 'academic_activity_pdf', FileSpecHelper.pdf.path, make_visible: true
        attach_file 'academic_activity_complementary_files', FileSpecHelper.zip.path, make_visible: true

        submit_form('input[name="commit"]')

        expect(page).to have_current_path(show_url)
        expect(page).to have_flash(:success, text: flash_message('update.f'))

        expect(find_by_id('academic_activity_title').value).to eq attributes[:title]
        expect(find_by_id('academic_activity_summary').value).to eq attributes[:summary]
      end
    end

    context 'when uploads are not valid' do
      it 'shows errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)

        expect(page).to have_content(blank_error_message)
        expect(page).to have_content(blank_error_message)
        expect(page).to have_content(blank_error_message)
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

        attach_file 'academic_activity_pdf', FileSpecHelper.pdf.path, make_visible: true
        attach_file 'academic_activity_complementary_files', FileSpecHelper.zip.path, make_visible: true

        submit_form('input[name="commit"]')

        expect(page).to have_current_path(show_url)
        expect(page).to have_flash(:success, text: flash_message('update.f'))

        expect(find_by_id('academic_activity_title').value).to eq attributes[:title]
        expect(find_by_id('academic_activity_summary').value).to eq attributes[:summary]
      end
    end

    context 'when the upload is not valid' do
      it 'shows errors' do
        fill_in 'academic_activity_title', with: ''
        fill_in 'academic_activity_summary', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)

        expect(page).to have_content(blank_error_message)
        expect(page).to have_content(blank_error_message)
      end
    end
  end
end
