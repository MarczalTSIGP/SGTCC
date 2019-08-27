module Helpers
  module Select
    def orientation_in_progress_option
      I18n.t('enums.orientation.status.select.IN_PROGRESS')
    end

    def orientation_renewed_option
      I18n.t('enums.orientation.status.select.RENEWED')
    end

    def orientation_approved_option
      I18n.t('enums.orientation.status.select.APPROVED')
    end

    def orientation_canceled_option
      I18n.t('enums.orientation.status.select.CANCELED')
    end
  end
end
