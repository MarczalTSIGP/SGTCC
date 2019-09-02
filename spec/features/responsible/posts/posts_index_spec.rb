require 'rails_helper'

describe 'Post::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:posts) { create_list(:post, 3) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_posts_path
  end

  describe '#index' do
    context 'when shows all posts' do
      it 'shows all posts with options' do
        posts.each do |post|
          expect(page).to have_contents([post.title,
                                         short_date(post.created_at),
                                         short_date(post.updated_at)])
        end
      end
    end
  end
end
