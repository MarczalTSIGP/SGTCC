require 'rails_helper'

RSpec.describe Dashboard::ResponsibleReport do
  describe '#current_tcc_one_orientations' do
    it 'uses the centralized current calendar period' do
      report = described_class.new

      allow(Calendar).to receive_messages(current_year: 2026, current_semester: 2)
      allow(report).to receive_messages(count_orientations: 0,
                                        count_orientation_status: 0,
                                        orientations_link: [])

      report.send(:current_tcc_one_orientations)

      expect(report).to have_received(:count_orientations).with('one', 2026, 2)
      expect(report).to have_received(:count_orientation_status).with('one', 2026, 2,
                                                                      'IN_PROGRESS')
    end
  end

  describe '#current_tcc_two_orientations' do
    it 'uses the centralized current calendar period' do
      report = described_class.new

      allow(Calendar).to receive_messages(current_year: 2026, current_semester: 2)
      allow(report).to receive_messages(count_orientations: 0,
                                        count_orientation_status: 0,
                                        orientations_link: [])

      report.send(:current_tcc_two_orientations)

      expect(report).to have_received(:count_orientations).with('two', 2026, 2)
      expect(report).to have_received(:count_orientation_status).with('two', 2026, 2,
                                                                      'IN_PROGRESS')
    end
  end
end
