require 'rails_helper'

RSpec.describe BaseActivity do
  subject(:base_activity) { described_class.new }

  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:tcc) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_presence_of(:identifier) }

    context 'when send document type' do
      before do
        base_activity.base_activity_type = create(:base_activity_type_send_document)
      end

      it { is_expected.to validate_presence_of(:identifier) }
    end

    context 'when info type' do
      before do
        base_activity.base_activity_type = create(:base_activity_type_info)
      end

      it { is_expected.not_to validate_presence_of(:identifier) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:base_activity_type) }
  end
end
