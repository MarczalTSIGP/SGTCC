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
    tcc_routes = '^\/professors\/supervisions(\/(tcc_one|tcc_two))?$'
    match_link?("(#{tcc_routes})")
  end

  def supervisions_active_link?
    return true if supervisions_tcc_one_or_two_active_link?
    show_route = '^\/professors\/supervisions\/\\d+$'
    match_link?("(#{show_route})")
  end

  def supervisions_history_active_link?
    match_link?('^\/professors\/supervisions\/history$')
  end
end
