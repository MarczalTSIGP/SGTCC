module Dashboard
  # Ranking de orientadores por número de orientações aprovadas, em ordem decrescente.
  # `Orientation.approved` já pré-carrega `advisor: [:scholarity]`; o ranking usa essa
  # associação em vez de buscar cada professor de novo (N+1 corrigido na REF-25).
  class ProfessorsRankingQuery
    def self.call
      new.call
    end

    def call
      Orientation.approved
                 .group_by(&:advisor)
                 .map { |advisor, orientations| [advisor.name_with_scholarity, orientations.size] }
                 .sort_by { |_, count| count }
                 .reverse
    end
  end
end
