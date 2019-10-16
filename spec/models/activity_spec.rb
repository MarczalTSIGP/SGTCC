require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:initial_date) }
    it { is_expected.to validate_presence_of(:final_date) }
    it { is_expected.to validate_presence_of(:identifier) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:calendar) }
    it { is_expected.to belong_to(:base_activity_type) }
    it { is_expected.to have_many(:academic_activities).dependent(:destroy) }
  end

  describe '#human_tccs' do
    it 'returns the tccs' do
      tccs = Activity.tccs
      hash = {}
      tccs.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }

      expect(Activity.human_tccs).to eq(hash)
    end
  end

  describe '#human_tcc_one_identifiers' do
    it 'returns the tcc one identifiers' do
      hash = Activity.human_tcc_identifiers.first(2).to_h
      expect(Activity.human_tcc_one_identifiers).to eq(hash)
    end
  end

  describe '#human_tcc_two_identifier' do
    it 'returns the tcc two identifier' do
      hash = {}
      hash[I18n.t('enums.tcc.identifiers.monograph')] = 'monograph'
      expect(Activity.human_tcc_two_identifier).to eq(hash)
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
        create(:activity, initial_date: Time.current - 1, final_date: Time.current + 1.day)
      end

      it 'returns true' do
        expect(activity.open?).to eq(true)
      end
    end

    context 'when activity is closed' do
      let(:activity) do
        create(:activity, initial_date: Time.current + 1.day, final_date: Time.current + 1.day)
      end

      it 'returns false' do
        expect(activity.open?).to eq(false)
      end
    end
  end
end
