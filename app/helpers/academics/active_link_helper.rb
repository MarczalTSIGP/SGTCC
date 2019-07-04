module Academics::ActiveLinkHelper
  def academics_calendars_active_link?
    index_route = '/academics/calendars'
    calendars_history_active_link?('academics') || match_link?("^(#{index_route})$")
  end

  def academics_activities_tcc_one_active_link?
    activities_tcc_active_link?('one', 'academics') && calendar_equal_current_calendar_tcc_one?
  end

  def academics_activities_tcc_two_active_link?
    activities_tcc_active_link?('two', 'academics') && calendar_equal_current_calendar_tcc_two?
  end

  def academics_signatures_pending_active_link?
    signatures_pending_active_link?('academics')
  end

  def academics_signatures_signed_active_link?
    signatures_signed_active_link?('academics')
  end
end
