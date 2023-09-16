module Responsible::OrientationsHelper 
  def dropdown_links(orientation)
    dropdown_links = []
    dropdown_links << { name: :details, path: responsible_orientation_path(orientation) }
    dropdown_links << { name: :activities, path: responsible_orientation_calendar_activities_path(orientation, orientation.current_calendar) }
    
    if orientation.meetings.present?
      dropdown_links << { name: :meetings, path: professors_orientation_meetings_path(orientation) } 
    end

    if orientation.documents.empty?
      dropdown_links << { name: :documents, path: responsible_orientation_documents_path(orientation) } 
    end

    if (orientation.can_be_edited? || orientation.can_be_destroyed?)
      dropdown_links << { name: :divider }
    end

    if orientation.can_be_edited?
        dropdown_links << { name: :edit, path: edit_responsible_orientation_path(orientation) }
    end
    
    if orientation.can_be_destroyed?
      dropdown_links << { name: :delete, path: responsible_orientation_path(orientation) }
    end
    
    dropdown_links
  end
end