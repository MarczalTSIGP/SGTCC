require 'rails_helper'

describe 'Academic::destroy', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:post) { create(:post) }
  let(:resource_name) { Post.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_posts_path
  end

  describe '#destroy' do
    context 'when post is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_post_path(post))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.m'))
        expect(page).not_to have_content(post.title)
      end
    end
  end
end
