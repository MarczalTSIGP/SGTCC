require 'rails_helper'

RSpec.describe Orientation, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:calendar) }
    it { is_expected.to belong_to(:academic) }
    it { is_expected.to belong_to(:advisor).class_name('Professor') }
    it { is_expected.to belong_to(:institution) }
    it { is_expected.to have_many(:orientation_supervisors).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:professor_supervisors).through(:orientation_supervisors) }
    it { is_expected.to have_many(:external_member_supervisors).through(:orientation_supervisors) }
  end

  describe '#short_title' do
    it 'returns the short title' do
      title = 'title' * 40
      orientation = create(:orientation, title: title)
      expect(orientation.short_title).to eq("#{title[0..35]}...")
    end

    it 'returns the title' do
      title = 'title'
      orientation = create(:orientation, title: title)
      expect(orientation.short_title).to eq(title)
    end
  end

  describe '#search' do
    let(:orientation) { create(:orientation) }

    context 'when finds orientation by attributes' do
      it 'returns orientation by title' do
        results_search = Orientation.search(orientation.title)
        expect(orientation.title).to eq(results_search.first.title)
      end
    end

    context 'when finds orientation by title with accents' do
      it 'returns orientation' do
        orientation = create(:orientation, title: 'Sistema de Gestão')
        results_search = Orientation.search('Sistema de Gestao')
        expect(orientation.title).to eq(results_search.first.title)
      end
    end

    context 'when finds orientation by title on search term with accents' do
      it 'returns orientation' do
        orientation = create(:orientation, title: 'Sistema de Gestao')
        results_search = Orientation.search('Sistema de Gestão')
        expect(orientation.title).to eq(results_search.first.title)
      end
    end

    context 'when finds orientation by title ignoring the case sensitive' do
      it 'returns orientation by attribute' do
        orientation = create(:orientation, title: 'Sistema')
        results_search = Orientation.search('sistema')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by search term' do
        orientation = create(:orientation, title: 'sistema')
        results_search = Orientation.search('SISTEMA')
        expect(orientation.title).to eq(results_search.first.title)
      end
    end

    context 'when returns orientations ordered by title' do
      it 'returns ordered' do
        create_list(:orientation, 30)
        orientations_ordered = Orientation.order(:title)
        orientation = orientations_ordered.first
        results_search = Orientation.search.order(:title)
        expect(orientation.title). to eq(results_search.first.title)
      end
    end
  end
end
