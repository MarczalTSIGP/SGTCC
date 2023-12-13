require 'rails_helper'

describe 'Activity::create', type: :feature, js: true do
  let(:academic) { create(:academic) }
  let!(:activity) { create(:activity) }
  let(:calendar) { activity.calendar }
  let(:show_url) { academics_calendar_activity_path(calendar, activity) }
  let(:resource_name) { Activity.model_name.human }

  before do
    login_as(academic, scope: :academic)
  end

  describe '#create' do
    before do
      visit show_url
    end

    context 'when standardize title automatically' do
      it 'alter title test one' do
        title = 'Pilas: um sistema web para gerenciamento do consumo de guloseimas ' \
                'em uma empresa de tecnologia'
        formatted_title = 'Pilas: Um Sistema Web para Gerenciamento do ' \
                          'Consumo de Guloseimas em uma Empresa de ' \
                          'Tecnologia'

        summary = 'explicação do tcc'

        fill_in 'academic_activity_title', with: title
        fill_in 'academic_activity_summary', with: summary

        expect(page).to have_css('.custom-file-input', visible: :hidden)
        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'academic_activity_pdf', FileSpecHelper.pdf.path
        attach_file 'academic_activity_complementary_files', FileSpecHelper.zip.path

        submit_form('input[name="commit"]')

        expect(page).to have_current_path show_url
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(find('#academic_activity_title').value).to eq formatted_title
      end

      it 'alter title test two' do
        title = 'PILAS: UM SISTEMA WEB PARA GERENCIAMENTO DO ' \
                'CONSUMO DE GULOSEIMAS EM UMA EMPRESA DE ' \
                'TECNOLOGIA'
        formatted_title = 'Pilas: Um Sistema Web para Gerenciamento do ' \
                          'Consumo de Guloseimas em uma Empresa de ' \
                          'Tecnologia'
        summary = 'explicação do tcc'

        fill_in 'academic_activity_title', with: title
        fill_in 'academic_activity_summary', with: summary

        expect(page).to have_css('.custom-file-input', visible: :hidden)
        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'academic_activity_pdf', FileSpecHelper.pdf.path
        attach_file 'academic_activity_complementary_files', FileSpecHelper.zip.path

        submit_form('input[name="commit"]')

        expect(page).to have_current_path show_url
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(find('#academic_activity_title').value).to eq formatted_title
      end

      it 'alter title test three' do
        title = 'Pilas: um sistema web PARA gerenciamento DO consumo DE guloseimas ' \
                'EM UMA empresa de tecnologia'
        formatted_title = 'Pilas: Um Sistema Web para Gerenciamento do Consumo de Guloseimas ' \
                          'em uma Empresa de Tecnologia'
        summary = 'explicação do tcc'

        fill_in 'academic_activity_title', with: title
        fill_in 'academic_activity_summary', with: summary

        expect(page).to have_css('.custom-file-input', visible: :hidden)
        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'academic_activity_pdf', FileSpecHelper.pdf.path
        attach_file 'academic_activity_complementary_files', FileSpecHelper.zip.path

        submit_form('input[name="commit"]')

        expect(page).to have_current_path show_url
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(find('#academic_activity_title').value).to eq formatted_title
      end
    end
  end
end
