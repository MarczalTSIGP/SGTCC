require 'rails_helper'

RSpec.describe Populate::Calendars do
  describe '#populate' do
    it 'creates calendars in the same tcc order using the enum persisted values' do
      expect { described_class.new.populate }.to change(Calendar, :count).by(8)

      tcc_values = Calendar.order(:created_at).last(8).map do |calendar|
        calendar.read_attribute_before_type_cast(:tcc)
      end

      expect(tcc_values).to eq([2, 1, 2, 1, 2, 1, 2, 1])
    end
  end
end
