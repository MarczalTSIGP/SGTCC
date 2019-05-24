module Professors::ActiveLinkHelper
  def professors_orientations_active_link?
    orientations_active_link?('professors') &&
      (calendar_equal_current_calendar_tcc_one? ||
      calendar_equal_current_calendar_tcc_two?)
  end

  def professors_orientations_history_active_link?
    match_history_link = match_link?('/professors/orientations/history')
    current_calendar = !(calendar_equal_current_calendar_tcc_one? ||
                        calendar_equal_current_calendar_tcc_two?)
    show_orientation = '/professors/orientations/\\d+'
    match_calendar_from_history = (match_link?(show_orientation) && current_calendar)
    match_history_link || match_calendar_from_history
  end

  def supervisions_tcc_one_or_two_active_link?
    match_link?('^\/professors\/supervisions(\/(tcc_one|tcc_two))?$')
  end

  def supervisions_show_link?
    match_link?('^\/professors\/supervisions\/\\d+$')
  end

  def supervisions_current_calendar_link?
    calendar = @orientation&.calendar
    Calendar.current_by_tcc_one?(calendar) || Calendar.current_by_tcc_two?(calendar)
  end

  def supervisions_active_link?
    return true if supervisions_tcc_one_or_two_active_link?
    supervisions_show_link? && supervisions_current_calendar_link?
  end

  def supervisions_history_active_link?
    match_link?('^\/professors\/supervisions\/history$') ||
      (supervisions_show_link? && !supervisions_current_calendar_link?)
  end
end
