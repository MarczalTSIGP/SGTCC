require 'rails_helper'

RSpec.describe Professor do
  subject(:professor) { described_class.new }

  describe '#orientations_to_form' do
    let(:orientation) { create(:orientation) }
    let(:professor) { orientation.advisor }

    it 'is equal professor request data' do
      order_by = 'calendars.year DESC, calendars.semester ASC, calendars.tcc ASC, academics.name'
      data = professor.orientations.includes(:academic, :calendars)
                      .order(order_by).map do |orientation|
        [orientation.id, orientation.academic_with_calendar]
      end
      expect(professor.orientations_to_form).to eq(data)
    end
  end

  describe '#tcc_one_approved' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation_tcc_one, advisor: professor) }

    it 'returns the tcc one approved' do
      orientations_approved = professor.orientations.tcc_one('APPROVED')
      expect(professor.tcc_one_approved).to eq(orientations_approved)
    end
  end

  describe '#tcc_two_approved' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation_tcc_two, advisor: professor) }

    it 'returns the tcc two approved' do
      orientations_approved = professor.orientations.tcc_two('APPROVED')
      expect(professor.tcc_two_approved).to eq(orientations_approved)
    end
  end

  describe '#tcc_one_in_progress' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation_tcc_one, advisor: professor) }

    it 'returns the tcc one in progress' do
      orientations_approved = professor.orientations.tcc_one('IN_PROGRESS')
      expect(professor.tcc_one_in_progress).to eq(orientations_approved)
    end
  end

  describe '#tcc_two_in_progress' do
    let(:professor) { create(:professor) }
    let(:orientation) { create(:orientation_tcc_two, advisor: professor) }

    it 'returns the tcc two in progress' do
      orientations_approved = professor.orientations.tcc_two('IN_PROGRESS')
      expect(professor.tcc_two_in_progress).to eq(orientations_approved)
    end
  end
end
