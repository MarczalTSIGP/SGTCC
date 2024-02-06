require 'rails_helper'

describe 'Image::create', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Image.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_image_path
    end

    context 'when image is valid' do
      it 'create an image' do
        attributes = attributes_for(:image)
        fill_in 'image_name', with: attributes[:name]

        page.execute_script("$('.custom-file-input').css('opacity', '1')")
        attach_file 'image_url', FileSpecHelper.image.path
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_images_path
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_content(attributes[:name])
      end
    end

    context 'when image is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.image_name')
        expect(page).to have_message(blank_error_message, in: 'div.image_url')
      end
    end
  end
end
