require 'rails_helper'

describe 'Image:update', :js do
  context 'when updates the image' do
    let(:professor) { create(:responsible) }
    let(:site_image) { create(:image) }

    before do
      login_as(professor, scope: :professor)
      visit edit_responsible_image_path(site_image)
    end

    context 'when data is valid' do
      it 'updates image' do
        attributes = attributes_for(:image)

        fill_in 'image_name', with: attributes[:name]

        page.execute_script("$('#image_url').css('opacity','1')")
        attach_file 'image_url', FileSpecHelper.image.path
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_images_path
        expect(page).to have_content(attributes[:name])
      end
    end

    context 'when data is not valid' do
      it 'does not update' do
        fill_in 'image_name', with: ''

        page.execute_script("$('#image_url').css('opacity','1')")
        attach_file 'image_url', FileSpecHelper.pdf.path
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: default_error_message)
        expect(page).to have_message(blank_error_message, in: 'div.image_name')
        expect(page).to have_message(image_error_message, in: 'div.image_url')
      end
    end
  end
end
