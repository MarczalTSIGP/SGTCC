module Professors::ActiveLinkHelper
  def professors_orientations_active_link?
    orientations_documents_link?('professors') ||
      orientations_active_link?('professors')
  end

  def professors_orientations_history_active_link?
    match_link?('/professors/orientations/history')
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
