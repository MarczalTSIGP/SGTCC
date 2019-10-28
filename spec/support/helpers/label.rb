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

    def confirm_judgment_label
      I18n.t('views.buttons.confirm_judgment')
    end

    def concede_label
      I18n.t('views.buttons.concede')
    end

    def dismiss_label
      I18n.t('views.buttons.dismiss')
    end

    def conceded_label
      I18n.t('views.labels.conceded')
    end

    def dismissed_label
      I18n.t('views.labels.dismissed')
    end
  end
end
