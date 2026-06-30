require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe 'academic activities documents' do
    # Simulates a orientation with two tcc two calendars
    # and sends files in both.
    # Must consider the last one the correct.
    describe '.proposal' do
      let(:previous_calendar) { create(:calendar, :previous, :tcc_one) }
      let(:current_calendar) { create(:calendar, :current, :tcc_one) }

      let(:orientation) { create(:orientation_tcc_one) }
      let(:orientation_two) { create(:orientation_tcc_one) }
      let!(:academic_activity_two) do
        activity_two = create(:proposal_activity, calendar: current_calendar)
        create(:academic_activity, activity: activity_two, academic: orientation.academic)
      end

      before do
        orientation.calendars = [previous_calendar, current_calendar]
        activity_one = create(:project_activity, calendar: previous_calendar)
        create(:academic_activity, activity: activity_one, academic: orientation.academic)
      end

      it 'returns the proposal document' do
        expect(orientation.proposal).to eq(academic_activity_two)
        expect(orientation_two.proposal).to be_nil
      end

      it 'returns the final version of proposal document' do
        academic_activity_two.activity.update(final_version: true)

        expect(orientation.final_proposal).to eq(academic_activity_two)
        expect(orientation_two.proposal).to be_nil
      end
    end

    describe '.project' do
      let(:previous_calendar) { create(:calendar, :previous, :tcc_one) }
      let(:current_calendar) { create(:calendar, :current, :tcc_one) }

      let(:orientation) { create(:orientation_tcc_one) }
      let!(:academic_activity_two) do
        activity_two = create(:project_activity, calendar: current_calendar)
        create(:academic_activity, activity: activity_two, academic: orientation.academic)
      end

      before do
        orientation.calendars = [previous_calendar, current_calendar]
        activity_one = create(:project_activity, calendar: previous_calendar)
        create(:academic_activity, activity: activity_one, academic: orientation.academic)
      end

      it 'returns the project document' do
        expect(orientation.project).to eq(academic_activity_two)
      end

      it 'returns the final version of project document' do
        academic_activity_two.activity.update(final_version: true)
        expect(orientation.final_project).to eq(academic_activity_two)
      end
    end

    describe '.monograph' do
      let(:previous_calendar) { create(:calendar, :previous, :tcc_two) }
      let(:current_calendar) { create(:calendar, :current, :tcc_two) }

      let(:orientation) { create(:orientation_tcc_two) }
      let!(:academic_activity) do
        activity_two = create(:monograph_activity, calendar: current_calendar)
        create(:academic_activity, activity: activity_two, academic: orientation.academic)
      end

      before do
        orientation.calendars = [previous_calendar, current_calendar]
        activity_one = create(:monograph_activity, calendar: previous_calendar)
        create(:academic_activity, activity: activity_one, academic: orientation.academic)
      end

      it 'returns the monograph document' do
        expect(orientation.monograph).to eq(academic_activity)
      end

      it 'returns the final version of monograph document' do
        academic_activity.activity.update(final_version: true)
        expect(orientation.final_monograph).to eq(academic_activity)
      end
    end
  end
end
