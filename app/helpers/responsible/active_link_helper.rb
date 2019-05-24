module Responsible::ActiveLinkHelper
  def responsible_orientations_active_link?
    orientations_active_link?('responsible')
  end

  def responsible_orientations_tcc_one_active_link?
    orientations_tcc_one_active_link?('responsible')
  end

  def responsible_orientations_tcc_two_active_link?
    orientations_tcc_two_active_link?('responsible')
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
