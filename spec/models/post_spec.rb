require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:fa_icon) }
  end

  describe '#after_save' do
    let!(:site) { create(:site) }
    let!(:post) { create(:post) }

    before do
      site.reload
    end

    it 'save the post to sidebar and object is equal 1' do
      expect(site.sidebar.size).to eq(1)
    end

    it 'removes the post and save to sidebar and attribute is updated' do
      new_title = 'Test'
      post.update(title: new_title)
      post_attributes = [{ "name": post.title, "url": post.url,
                           "icon": post.fa_icon, "order": 1, "identifier": post.identifier }]
      site.reload
      expect(site.sidebar.to_json).to eq(post_attributes.to_json)
    end
  end

  describe '#after_destroy' do
    let!(:site) { create(:site) }
    let!(:posts) { create_list(:post, 2) }

    it 'remove the post from the sidebar and the object is equal 1' do
      posts.last.destroy
      site.reload
      expect(site.sidebar.size).to eq(1)
    end
  end
end
