module Responsible::ActiveLinkHelper
  def responsible_orientations_active_link?
    activities = '^/responsible/orientations/\\d+/calendars/\\d+/activities(/\\d+)?$'

    (orientations_active_link?('responsible') && !@calendar&.current?) ||
      orientations_documents_link?('responsible') ||
      match_link?(activities)
  end

  def responsible_orientations_show_or_edit_link?
    match_link?('^\/responsible/orientations\/\\d+(\/edit)?$')
  end

  def responsible_orientations_tcc_one_active_link?
    return orientations_tcc_one_active_link?('responsible') if @calendar.blank?

    responsible_orientations_show_or_edit_link? && Calendar.current_by_tcc_one?(@calendar)
  end

  def responsible_orientations_tcc_two_active_link?
    return orientations_tcc_two_active_link?('responsible') if @calendar.blank?

    responsible_orientations_show_or_edit_link? && Calendar.current_by_tcc_two?(@calendar)
  end

  def responsible_calendars_active_link?
    calendars_active_link?('responsible')
  end

  def responsible_current_activities_tcc_one_active_link?
    activities_tcc_active_link?('one', 'responsible') && calendar_equal_current_calendar_tcc_one?
  end

  def responsible_current_activities_tcc_two_active_link?
    activities_tcc_active_link?('two', 'responsible') && calendar_equal_current_calendar_tcc_two?
  end

  def responsible_base_activities_active_link?
    match_link?('/responsible/base_activities')
  end
end
