require 'active_support/concern'

module OrientationReport
  extend ActiveSupport::Concern

  included do
    def self.professors_ranking
      professors = tcc_two('APPROVED').group_by(&:advisor_id)
      orientations = professors.values.map(&:size)
      professors = professors_ranking_data(professors.keys, orientations)
      professors.sort_by { |professor| professor[1] }.reverse
    end

    def self.professors_ranking_data(professor_ids, orientations)
      professor_ids.map.with_index do |professor_id, index|
        [Professor.find(professor_id).name_with_scholarity,
         orientations[index]]
      end
    end
  end
end
