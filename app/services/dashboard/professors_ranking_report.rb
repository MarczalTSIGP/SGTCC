module Dashboard
  class ProfessorsRankingReport
    def self.call
      new.call
    end

    def call
      professors_by_id = Orientation.approved.group_by(&:advisor_id)
      counts = professors_by_id.values.map(&:size)
      build_ranking(professors_by_id.keys, counts)
    end

    private

    def build_ranking(professor_ids, counts)
      data = professor_ids.map.with_index do |id, i|
        [Professor.find(id).name_with_scholarity, counts[i]]
      end
      data.sort_by { |_, count| count }.reverse
    end
  end
end
