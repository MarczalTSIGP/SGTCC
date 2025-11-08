require 'rails_helper'

RSpec.describe Activity do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:initial_date) }
    it { is_expected.to validate_presence_of(:final_date) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:calendar).optional(true) }
    it { is_expected.to belong_to(:base_activity_type) }
    it { is_expected.to have_many(:academic_activities).dependent(:destroy) }
  end

  describe '#human_tccs' do
    it 'returns the tccs' do
      tccs = described_class.tccs
      hash = {}
      tccs.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }

      expect(described_class.human_tccs).to eq(hash)
    end
  end

  describe '#human_tcc_one_identifiers' do
    it 'returns the tcc one identifiers' do
      hash = described_class.human_tcc_identifiers.first(2).to_h
      expect(described_class.human_tcc_one_identifiers).to eq(hash)
    end
  end

  describe '#deadline' do
    let(:activity) { create(:activity) }

    it 'returns the deadline' do
      initial_date = I18n.l(activity.initial_date, format: :datetime)
      final_date = I18n.l(activity.final_date, format: :datetime)
      expect(activity.deadline).to eq(I18n.t('time.deadline',
                                             initial_date:,
                                             final_date:))
    end
  end

  describe '#status' do
    let(:activity) { create(:activity) }

    it 'return expired' do
      activity.final_date = 1.day.ago

      expect(activity.status).to eq(:expired)
    end

    it 'return ontime' do
      activity.final_date = Time.zone.now

      expect(activity.status).to eq(:ontime)
    end

    it 'return in_the_future' do
      expect(activity.status).to eq(:in_the_future)
    end
  end

  describe '#academic_activity' do
    let(:activity) { create(:activity) }
    let(:orientation) { create(:orientation) }

    let!(:academic_activity) do
      create(:academic_activity, activity:, academic: orientation.academic)
    end

    it 'returns the academic activity' do
      expect(activity.academic_activity(orientation)).to eq(academic_activity)
    end
  end

  describe '#identifier_translated' do
    let(:activity) { create(:activity) }

    it 'returns the identifier translated' do
      identifier_translated = I18n.t("enums.activity.identifiers.#{activity.identifier}")
      expect(activity.identifier_translated).to eq(identifier_translated)
    end
  end

  describe '#expired?' do
    context 'when time is expired' do
      let(:activity) { create(:activity, final_date: Time.current - 1) }

      it 'returns true' do
        expect(activity.expired?).to be(true)
      end
    end

    context 'when time is not expired' do
      let(:activity) { create(:activity, final_date: Time.current + 3) }

      it 'returns false' do
        expect(activity.expired?).to be(false)
      end
    end
  end

  describe '#open?' do
    context 'when activity is open' do
      let(:activity) do
        create(:activity, initial_date: Time.current - 1, final_date: 1.day.from_now)
      end

      it 'returns true' do
        expect(activity.open?).to be(true)
      end
    end

    context 'when activity is closed' do
      let(:activity) do
        create(:activity, initial_date: 1.day.from_now, final_date: 1.day.from_now)
      end

      it 'returns false' do
        expect(activity.open?).to be(false)
      end
    end
  end

  describe '.find_academic_activity_by_academic' do
    let!(:academic_activity) { create(:academic_activity) }

    it 'returns the academic activity' do
      activity = academic_activity.activity
      academic = academic_activity.academic
      expect(activity.find_academic_activity_by_academic(academic)).to eq(academic_activity)
    end
  end

  describe '#academic_responses' do
    let(:activity) { create(:activity) }

    let(:academic_one)   { create(:academic, name: 'A') }
    let(:academic_two)   { create(:academic, name: 'B') }

    let(:orientation_one) { create(:orientation, academic: academic_one) }
    let(:orientation_two) { create(:orientation, academic: academic_two) }

    before do
      create(:orientation_calendar, orientation: orientation_one, calendar: activity.calendar)
      create(:orientation_calendar, orientation: orientation_two, calendar: activity.calendar)
    end

    it 'returns all academics associated with the calendar' do
      academics = activity.responses.academics
      expect(academics.pluck(:id)).to contain_exactly(academic_one.id, academic_two.id)
    end

    it 'have total that should sent' do
      expect(activity.responses.total_should_sent).to eq(2)
    end

    it 'have total of sent' do
      expect(activity.responses.total_sent).to eq(0)
    end

    it 'has an academic response with property sent' do
      create(:academic_activity, academic: academic_one, activity:)

      academic_response_one = activity.responses.academics.first
      academic_response_two = activity.responses.academics.second

      expect(academic_response_one.sent?).to be(true)
      expect(academic_response_two.sent?).to be(false)

      expect(activity.responses.total_sent).to eq(1)
    end
  end

  describe 'callbacks' do
    let!(:calendar) { create(:calendar) }

    let!(:orientation) { create(:orientation, calendars: [calendar]) }

    let(:activity) { create(:activity, calendar: calendar) }

    describe 'when a new activity is created calls after_commit: :create' do
      it 'enqueues Notifications::CreateJob for each recipient' do
        expect do
          activity
        end.to enqueue_job(Notifications::CreateJob).exactly(2).times
      end

      it 'enqueues Notifications::CreateJob with the correct arguments for the academic' do
        academic = orientation.academic

        expect do
          activity
        end.to have_enqueued_job(Notifications::CreateJob).with(
          hash_including(
            notification_type: 'activity_calendar_created',
            recipient: academic,
            event_key: "activity_calendar:#{calendar.id}:created:user:Academic:#{academic.id}"
          )
        )
      end

      it 'does not enqueue jobs if the calendar has no orientations' do
        calendar_sem_orientacoes = create(:calendar)

        expect do
          create(:activity, calendar: calendar_sem_orientacoes)
        end.not_to have_enqueued_job(Notifications::CreateJob)
      end
    end

    describe 'when a activity is updated calls after_commit: :update' do
      let!(:activity) { create(:activity, calendar: calendar) }

      before do
        clear_enqueued_jobs
      end

      it 'enqueues Notifications::CreateJob for each recipient when updating' do
        expect do
          activity.update(name: 'Updated Activity Name')
        end.to enqueue_job(Notifications::CreateJob).exactly(2).times
      end

      it 'enqueues Notifications::CreateJob with the correct arguments for the advisor' do
        advisor = orientation.advisor

        expect do
          activity.update(name: 'Updated Activity Name')
        end.to have_enqueued_job(Notifications::CreateJob).with(
          hash_including(
            notification_type: 'activity_calendar_updated',
            recipient: advisor,
            event_key: "activity_calendar:#{calendar.id}:updated:user:Professor:#{advisor.id}"
          )
        )
      end
    end
  end
end
