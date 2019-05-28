module TccOneProfessors::ActiveLinkHelper
  def tcc_one_professors_activities_tcc_one_active_link?
    activities_tcc_active_link?('one', 'tcc_one_professors') &&
      calendar_equal_current_calendar_tcc_one?
  end

  def tcc_one_professors_calendar_orientations_active_link?
    match_link?('\/tcc_one_professors\/calendars\/\\d+/orientations')
  end

  def tcc_one_professors_orientations_tcc_one_active_link?
    tcc_one_professors_calendar_orientations_active_link? &&
      tcc_one_professors_current_calendar_link?
  end

  def tcc_one_professors_calendars_active_link?
    (calendars_active_link?('tcc_one_professors') ||
       (tcc_one_professors_calendar_orientations_active_link? &&
        !tcc_one_professors_current_calendar_link?))
  end

  def tcc_one_professors_current_calendar_link?
    Calendar.current_by_tcc_one?(@calendar)
  end
end
