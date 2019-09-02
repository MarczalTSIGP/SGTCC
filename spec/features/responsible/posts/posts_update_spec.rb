require 'rails_helper'

describe 'Post::update', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Post.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:post) { create(:post) }

    before do
      visit edit_responsible_post_path(post)
    end

    context 'when data is valid' do
      it 'updates the post' do
        attributes = attributes_for(:post)
        fill_in 'post_title', with: attributes[:title]
        fill_in 'post_url', with: attributes[:url]
        fill_in 'post_fa_icon', with: attributes[:fa_icon]

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_post_path(post)
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_contents([attributes[:title],
                                       attributes[:url],
                                       attributes[:fa_icon]])
      end
    end

    context 'when the post is not valid' do
      it 'show errors' do
        fill_in 'post_title', with: ''
        fill_in 'post_url', with: ''
        fill_in 'post_fa_icon', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.post_title')
        expect(page).to have_message(blank_error_message, in: 'div.post_url')
        expect(page).to have_message(blank_error_message, in: 'div.post_fa_icon')
      end
    end
  end
end
