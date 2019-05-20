require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_presence_of(:initial_date) }
    it { is_expected.to validate_presence_of(:final_date) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:calendar) }
    it { is_expected.to belong_to(:base_activity_type) }
  end

  describe '#human_tccs' do
    it 'returns the tccs' do
      tccs = Activity.tccs
      hash = {}
      tccs.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }

      expect(Activity.human_tccs).to eq(hash)
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
end
