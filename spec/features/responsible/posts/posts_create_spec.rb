require 'rails_helper'

describe 'Post::create', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Post.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_post_path
    end

    context 'when post is valid' do
      it 'create a post' do
        attributes = attributes_for(:post)
        fill_in 'post_title', with: attributes[:title]
        fill_in 'post_url', with: attributes[:url]
        fill_in 'post_fa_icon', with: attributes[:fa_icon]
        find('.fa-bold').click

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_posts_path
        expect(page).to have_flash(:success, text: message('create.m'))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when post is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.post_title')
        expect(page).to have_message(blank_error_message, in: 'div.post_url')
        expect(page).to have_message(blank_error_message, in: 'div.post_fa_icon')
        expect(page).to have_message(blank_error_message, in: 'div.post_content')
      end
    end
  end
end
