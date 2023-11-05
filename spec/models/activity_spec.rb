require 'rails_helper'

RSpec.describe Activity, type: :model do
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
                                             initial_date: initial_date,
                                             final_date: final_date))
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
      create(:academic_activity, activity: activity, academic: orientation.academic)
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
        expect(activity.expired?).to eq(true)
      end
    end

    context 'when time is not expired' do
      let(:activity) { create(:activity, final_date: Time.current + 3) }

      it 'returns false' do
        expect(activity.expired?).to eq(false)
      end
    end
  end

  describe '#open?' do
    context 'when activity is open' do
      let(:activity) do
        create(:activity, initial_date: Time.current - 1, final_date: 1.day.from_now)
      end

      it 'returns true' do
        expect(activity.open?).to eq(true)
      end
    end

    context 'when activity is closed' do
      let(:activity) do
        create(:activity, initial_date: 1.day.from_now, final_date: 1.day.from_now)
      end

      it 'returns false' do
        expect(activity.open?).to eq(false)
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

  describe '#responses' do
    let(:calendar) { create(:calendar) }
    let(:activity) { create(:activity, calendar: calendar) }
    let(:academic_one) { create(:academic) }
    let(:academic_two) { create(:academic) }
    let(:academic_three) { create(:academic) }
    let(:orientation_one) { create(:orientation, academic: academic_one) }
    let(:orientation_two) { create(:orientation, academic: academic_two) }
    let(:orientation_three) { create(:orientation, academic: academic_three) }

    before do
      create(:orientation_calendar, orientation: orientation_one, calendar: calendar)
      create(:orientation_calendar, orientation: orientation_two, calendar: calendar)
      create(:orientation_calendar, orientation: orientation_three, calendar: calendar)
    end

    it 'returns count with no response answered' do
      result = activity.responses

      expect(result.count).to eq(0)
      expect(result.total).to eq(3)
    end

    it 'returns count with 2 response answered' do
      create(:academic_activity, academic: academic_one, activity: activity)
      create(:academic_activity, academic: academic_two, activity: activity)

      result = activity.responses

      expect(result.count).to eq(2)
      expect(result.total).to eq(3)
    end

    it 'returns non-negative response counts' do
      response_counts = activity.responses

      expect(response_counts.total).to be >= 0
      expect(response_counts.count).to be >= 0
    end
  end

  describe '#academics' do
    let(:calendar) { create(:calendar) }
    let(:calendar_two) { create(:calendar) }

    let(:activity) { create(:activity, calendar: calendar) }

    let(:academic_one) { create(:academic) }
    let(:academic_two) { create(:academic) }
    let(:academic_three) { create(:academic) }

    let(:orientation_one) { create(:orientation, academic: academic_one) }
    let(:orientation_two) { create(:orientation, academic: academic_two) }
    let(:orientation_three) { create(:orientation, academic: academic_three) }

    before do
      create(:orientation_calendar, orientation: orientation_one, calendar: calendar)
      create(:orientation_calendar, orientation: orientation_two, calendar: calendar)
      create(:orientation_calendar, orientation: orientation_three, calendar: calendar_two)
    end

    it 'returns all academics associated with the calendar' do
      academics = activity.academics

      expect(academics).to contain_exactly(academic_one, academic_two)
      expect(academics).not_to include(academic_three)
    end

    it 'does not have an academic with property sent academic activity as true' do
      academics_with_activity_sent = activity.academics.select do |academic|
        academic.sent_academic_activity == 'false'
      end
      expect(academics_with_activity_sent.size).to eq(2)
    end

    it 'has an academic with property sent academic activity as true' do
      create(:academic_activity, academic: academic_one, activity: activity)

      academic_with_activity_sent = activity
                                    .academics
                                    .find(&:sent_academic_activity)

      expect(academic_with_activity_sent).to eq(academic_one)
      expect(academic_with_activity_sent.sent_academic_activity).to eq('true')
    end
  end
end
