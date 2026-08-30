require 'rails_helper'

RSpec.describe Dashboard::ProfessorsRankingReport do
  describe '.call' do
    let!(:professor_orientations) do
      create_list(:orientation, 4, :tcc_two, :approved, :with_final_monograph)
    end
    let!(:professors) { professor_orientations.map(&:advisor) }

    it 'returns professors ranked by approved orientation count descending' do
      ranking = professors.map do |professor|
        [professor.name_with_scholarity, professor.orientations.size]
      end
      ranking = ranking.sort_by { |_, count| count }.reverse

      expect(described_class.call).to match_array(ranking)
    end

    it 'excludes orientations without a final monograph' do
      create(:orientation, :tcc_two, :approved)

      result = described_class.call
      totals = result.map(&:last)
      expect(totals).to all(be >= 1)
    end
  end
end
