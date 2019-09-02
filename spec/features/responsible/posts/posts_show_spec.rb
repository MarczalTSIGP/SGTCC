require 'rails_helper'

describe 'Post::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:post) { create(:post) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_post_path(post)
  end

  describe '#show' do
    context 'when shows the post' do
      it 'shows the post' do
        expect(page).to have_contents([post.title,
                                       post.url,
                                       post.fa_icon,
                                       complete_date(post.created_at),
                                       complete_date(post.updated_at)])
      end
    end
  end
end
