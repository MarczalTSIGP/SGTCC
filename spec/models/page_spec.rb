require 'rails_helper'

RSpec.describe Page, type: :model do
  describe 'validates' do
    subject { create(:page) }

    before do
      create(:site)
    end

    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url).case_insensitive }
    it { is_expected.to validate_presence_of(:menu_title) }
    it { is_expected.to validate_uniqueness_of(:menu_title).case_insensitive }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:fa_icon) }
  end

  describe '#after_save' do
    let!(:site) { create(:site) }
    let!(:page) { create(:page) }

    before do
      site.reload
    end

    it 'save the page to sidebar and object is equal 1' do
      expect(site.sidebar.size).to eq(1)
    end

    it 'removes the page and save to sidebar and attribute is updated' do
      new_menu_title = 'Test'
      page.update(menu_title: new_menu_title)
      page_attributes = [{ "name": page.menu_title, "url": page.url,
                           "icon": page.fa_icon, "order": 1, "identifier": page.identifier }]
      site.reload
      expect(site.sidebar.to_json).to eq(page_attributes.to_json)
    end
  end

  describe '#after_destroy' do
    let!(:site) { create(:site) }
    let!(:pages) { create_list(:page, 2) }

    it 'remove the page from the sidebar and the object is equal 1' do
      pages.last.destroy
      site.reload
      expect(site.sidebar.size).to eq(1)
    end
  end
end
