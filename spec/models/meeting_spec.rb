require 'rails_helper'

RSpec.describe Meeting, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
  end

  describe '#search' do
    let(:meeting) { create(:meeting) }

    context 'when finds meeting by attributes' do
      it 'returns meeting by title' do
        results_search = Meeting.search(meeting.title)
        expect(meeting.title).to eq(results_search.first.title)
      end
    end

    context 'when finds meeting by title with accents' do
      it 'returns meeting' do
        meeting = create(:meeting, title: 'Reunião')
        results_search = Meeting.search('Reuniao')
        expect(meeting.title).to eq(results_search.first.title)
      end
    end

    context 'when finds meeting by title on search term with accents' do
      it 'returns meeting' do
        meeting = create(:meeting, title: 'Reuniao')
        results_search = Meeting.search('Reunião')
        expect(meeting.title).to eq(results_search.first.title)
      end
    end

    context 'when finds meeting by title ignoring the case sensitive' do
      it 'returns meeting by attribute' do
        meeting = create(:meeting, title: 'Reuniao')
        results_search = Meeting.search('reuni')
        expect(meeting.title).to eq(results_search.first.title)
      end

      it 'returns meeting by search term' do
        meeting = create(:meeting, title: 'reuniao')
        results_search = Meeting.search('REUNI')
        expect(meeting.title).to eq(results_search.first.title)
      end
    end
  end
end
