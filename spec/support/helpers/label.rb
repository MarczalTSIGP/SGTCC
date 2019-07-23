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

    def orientations_in_progress_label
      I18n.t('reports.orientations.label.in_progress')
    end

    def orientations_approved_label
      I18n.t('reports.orientations.label.approved')
    end

    def orientations_renewed_label
      I18n.t('reports.orientations.label.renewed')
    end

    def orientations_canceled_label
      I18n.t('reports.orientations.label.canceled')
    end
  end
end
