module BreadcrumbTitle
  extend ActiveSupport::Concern

  def orientation_calendar_title(calendar = @calendar)
    I18n.t("breadcrumbs.orientations.tcc.#{calendar&.tcc}.calendar",
           calendar: calendar&.year_with_semester)
  end

  def edit_orientation_calendar_title
    I18n.t("breadcrumbs.orientations.tcc.#{@calendar&.tcc}.edit",
           calendar: @calendar&.year_with_semester)
  end

  def show_orientation_calendar_title(calendar = @calendar)
    I18n.t("breadcrumbs.orientations.tcc.#{calendar&.tcc}.show",
           calendar: calendar&.year_with_semester)
  end

  def show_supervision_calendar_title(calendar = @calendar)
    I18n.t("breadcrumbs.supervisions.tcc.#{calendar&.tcc}.show",
           calendar: calendar&.year_with_semester)
  end

  def supervision_calendar_title(calendar)
    I18n.t("breadcrumbs.supervisions.tcc.#{calendar&.tcc}.calendar",
           calendar: calendar&.year_with_semester)
  end

  def supervision_tcc_calendar_title(tcc = 'one')
    I18n.t("breadcrumbs.supervisions.tcc.#{tcc}.calendar",
           calendar: "#{Calendar.current_year}/#{Calendar.current_semester}")
  end
end
