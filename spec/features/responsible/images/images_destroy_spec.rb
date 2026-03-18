require 'rails_helper'

describe 'Image::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:image) { create(:image) }
  let(:resource_name) { Image.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_images_path
  end

  describe '#destroy' do
    context 'when image is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_image_path(image))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).to have_no_content(image.name)
      end
    end
  end
end
