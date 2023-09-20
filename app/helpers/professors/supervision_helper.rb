module Professors::SupervisionHelper
    def dropdown_links(orientation)
    links = []

    details_link(links, orientation)
    activities_link(links, orientation)
    documents_link(links, orientation)

    links
  end

  private

  def details_link(links, orientation)
    links << { name: :details, path: professors_supervision_path(orientation) }
  end

  def activities_link(links, orientation)
    links << {
      name: :activities,
      path: professors_supervision_calendar_activities_path(
        orientation,
        orientation.current_calendar
      )
    }
  end

  def documents_link(links, orientation)
    return if orientation.documents.blank?

    links << { name: :documents, path: professors_supervision_documents_path(orientation) }
  end

end
