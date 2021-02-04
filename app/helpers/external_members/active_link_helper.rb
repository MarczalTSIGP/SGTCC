module ExternalMembers::ActiveLinkHelper
  def external_members_calendars_active_link?
    index_route = '/external_members/calendars'
    calendars_history_active_link?('external_members') || match_link?("^(#{index_route})$")
  end

  def external_members_activities_tcc_one_active_link?
    activities_tcc_active_link?('one', 'external_members') # &&
    #  calendar_equal_current_calendar_tcc_one?
  end

  def external_members_activities_tcc_two_active_link?
    activities_tcc_active_link?('two', 'external_members') # &&
    #  calendar_equal_current_calendar_tcc_two?
  end

  def external_members_supervisions_active_link?
    supervisions_active_link?('external_members') ||
      supervisions_documents_link?('external_members')
  end

  def external_members_supervisions_history_active_link?
    # TODO:
    #supervisions_history_active_link?('external_members')
  end

  def external_members_documents_pending_active_link?
    documents_pending_active_link?('external_members')
  end

  def external_members_documents_signed_active_link?
    documents_signed_active_link?('external_members')
  end
end
