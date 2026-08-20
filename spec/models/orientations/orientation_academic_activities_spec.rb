require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe 'academic activities documents' do
    # Simulates a orientation with two tcc two calendars
    # and sends files in both.
    # Must consider the last one the correct.
    describe '.proposal' do
      let(:previous_calendar) do
        find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester - 1,
          tcc: Calendar.tccs[:one]
        )
      end
      let(:current_calendar) do
        find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:one]
        )
      end

      let(:orientation) { create(:orientation, :tcc_one) }
      let(:orientation_two) { create(:orientation, :tcc_one) }
      let!(:academic_activity_two) do
        activity_two = create(:activity, :proposal, calendar: current_calendar)
        create(:academic_activity, activity: activity_two, academic: orientation.academic)
      end

      before do
        orientation.calendars = [previous_calendar, current_calendar]
        activity_one = create(:activity, :project, calendar: previous_calendar)
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
      let(:previous_calendar) do
        find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester - 1,
          tcc: Calendar.tccs[:one]
        )
      end
      let(:current_calendar) do
        find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:one]
        )
      end

      let(:orientation) { create(:orientation, :tcc_one) }
      let!(:academic_activity_two) do
        activity_two = create(:activity, :project, calendar: current_calendar)
        create(:academic_activity, activity: activity_two, academic: orientation.academic)
      end

      before do
        orientation.calendars = [previous_calendar, current_calendar]
        activity_one = create(:activity, :project, calendar: previous_calendar)
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
      let(:previous_calendar) do
        find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester - 1,
          tcc: Calendar.tccs[:two]
        )
      end
      let(:current_calendar) do
        find_or_create_calendar(
          year: Calendar.current_year,
          semester: Calendar.current_semester,
          tcc: Calendar.tccs[:two]
        )
      end

      let(:orientation) { create(:orientation, :tcc_two) }
      let!(:academic_activity) do
        activity_two = create(:activity, :monograph, calendar: current_calendar)
        create(:academic_activity, activity: activity_two, academic: orientation.academic)
      end

      before do
        orientation.calendars = [previous_calendar, current_calendar]
        activity_one = create(:activity, :monograph, calendar: previous_calendar)
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
