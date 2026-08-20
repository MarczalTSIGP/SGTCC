require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:orientation_calendars).dependent(:destroy) }
    it { is_expected.to have_many(:calendars).through(:orientation_calendars) }
    it { is_expected.to belong_to(:academic) }
    it { is_expected.to belong_to(:advisor).class_name('Professor') }
    it { is_expected.to belong_to(:institution).optional }
    it { is_expected.to have_many(:signatures).dependent(:destroy) }
    it { is_expected.to have_many(:documents).through(:signatures) }
    it { is_expected.to have_many(:academic_activities).through(:academic) }
    it { is_expected.to have_many(:meetings).dependent(:destroy) }
    it { is_expected.to have_many(:examination_boards).dependent(:destroy) }
    it { is_expected.to have_many(:orientation_supervisors).dependent(:delete_all) }

    it 'is expected to have many professor supervisors' do
      expect(orientation).to have_many(:professor_supervisors).through(:orientation_supervisors)
                                                              .dependent(:destroy)
    end

    it 'is expected to have many external member supervisors' do
      expect(orientation).to have_many(:external_member_supervisors)
        .through(:orientation_supervisors).dependent(:destroy)
    end
  end

  describe '#short_title' do
    it 'returns the short title' do
      title = 'title' * 40
      orientation = create(:orientation, title:)
      expect(orientation.short_title).to eq("#{title[0..35]}...")
    end

    it 'returns the title' do
      title = 'title'
      orientation = create(:orientation, title:)
      expect(orientation.short_title).to eq(title)
    end
  end

  describe '#select_status_data' do
    it 'returns the select status data' do
      status_data = described_class.statuses.map do |index, field|
        [field, index.capitalize]
      end.sort!
      expect(described_class.select_status_data).to eq(status_data)
    end
  end
end
