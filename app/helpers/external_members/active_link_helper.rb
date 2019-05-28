module ExternalMembers::ActiveLinkHelper
  def external_members_calendars_active_link?
    index_route = '/external_members/calendars'
    calendars_history_active_link?('external_members') || match_link?("^(#{index_route})$")
  end

  def external_members_activities_tcc_one_active_link?
    activities_tcc_active_link?('one', 'external_members') &&
      calendar_equal_current_calendar_tcc_one?
  end

  def external_members_activities_tcc_two_active_link?
    activities_tcc_active_link?('two', 'external_members') &&
      calendar_equal_current_calendar_tcc_two?
  end
end
