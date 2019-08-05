module Helpers
  module Label
    def professors_label
      I18n.t('reports.professors.index')
    end

    def professors_total_label
      I18n.t('reports.professors.label.total')
    end

    def professors_available_label
      I18n.t('reports.professors.label.available')
    end

    def professors_unavailable_label
      I18n.t('reports.professors.label.unavailable')
    end
  end
end
