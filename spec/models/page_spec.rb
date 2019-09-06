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

  describe '#publisheds' do
    before do
      create_list(:page, 4)
    end

    it 'returns the pages published' do
      pages = Page.where(publish: true).order(:order)
      expect(Page.publisheds).to eq(pages)
    end
  end

  describe '#update_menu_order' do
    let!(:pages) { create_list(:page, 2) }
    let(:first_page) { pages.first }
    let(:second_page) { pages.last }
    let(:array) { [] }

    let(:data) do
      pages.reverse.map do |page|
        { 'id' => page.id }
      end
    end

    before do
      first_page.order = 2
      first_page.save

      second_page.order = 1
      second_page.save
    end

    it 'returns the update menu order' do
      array.push(first_page)
      array.push(second_page)
      expect(Page.update_menu_order(data)).to match_array(pages)
    end
  end
end
