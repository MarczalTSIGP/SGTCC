module ExternalMembers::OrientationsHelper
    def dropdown_links(orientation)
      links = []
  
      details_link(links, orientation)
      activities_link(links, orientation)
      documents_link(links, orientation)
      
      links
    end
  
    private
  
    def details_link(links, orientation)
      links << { name: :details, path: external_members_supervision_path(orientation) }
    end
  
    def activities_link(links, orientation)
      links << {
        name: :activities,
        path: external_members_supervision_calendar_activities_path(
          orientation,
          orientation.current_calendar
        )
      }
    end
  
    def documents_link(links, orientation)
      return if orientation.documents.blank?
  
      links << { name: :documents, path: external_members_supervision_documents_path(orientation) }
    end
  end
  