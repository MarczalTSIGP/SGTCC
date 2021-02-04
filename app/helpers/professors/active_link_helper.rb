module Professors::ActiveLinkHelper
  def professors_orientations_active_link?
    (orientations_documents_link?('professors') ||
      orientations_active_link?('professors')) #&&
      #(calendar_equal_current_calendar_tcc_one? ||
      #calendar_equal_current_calendar_tcc_two?)
  end

  def professors_orientations_history_active_link?
    match_history_link = match_link?('/professors/orientations/history')
    #current_calendar = !(calendar_equal_current_calendar_tcc_one? ||
    #                    calendar_equal_current_calendar_tcc_two?)
    show_orientation = '/professors/orientations/\\d+'
    match_calendar_from_history = (match_link?(show_orientation)) #&& current_calendar)
    match_history_link # || match_calendar_from_history
  end

  def professors_supervisions_active_link?
    supervisions_active_link?('professors') || supervisions_documents_link?('professors')
  end

  def professors_supervisions_history_active_link?
    supervisions_history_active_link?('professors')
  end

  def professors_documents_pending_active_link?
    documents_pending_active_link?('professors')
  end

  def professors_documents_signed_active_link?
    documents_signed_active_link?('professors')
  end
end
