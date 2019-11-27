module Academics::ActiveLinkHelper
  def academics_calendars_active_link?
    index_route = '/academics/calendars'
    calendars_history_active_link?('academics') || match_link?("^(#{index_route})$") ||
      academics_calendar_orientation_documents_active_link?
  end

  def academics_activities_tcc_one_active_link?
    activities_tcc_active_link?('one', 'academics') && calendar_equal_current_calendar_tcc_one?
  end

  def academics_activities_tcc_two_active_link?
    activities_tcc_active_link?('two', 'academics') && calendar_equal_current_calendar_tcc_two?
  end

  def academics_documents_pending_active_link?
    documents_pending_active_link?('academics')
  end

  def academics_documents_signed_active_link?
    documents_signed_active_link?('academics')
  end

  def academics_calendar_orientation_documents_active_link?
    match_link?('^\/academics/calendars/\\d+/orientations\/\\d+/documents?(\/\\d+)?$')
  end
end
