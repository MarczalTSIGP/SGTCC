module Professors::OrientationsHelper
   def dropdown_links(orientation)
        links = []
    
        details_link(links, orientation)
        activities_link(links, orientation)
        documents_link(links, orientation)
        meetings_link(links, orientation)
        edit_link(links, orientation)
        
        links
      end
    
      private
    
      def details_link(links, orientation)
        links << { name: :details, path: professors_orientation_path(orientation) }
      end
    
      def activities_link(links, orientation)
        links << {
          name: :activities,
          path: professors_orientation_calendar_activities_path(
            orientation,
            orientation.current_calendar
          )
        }
      end
    
      def documents_link(links, orientation)
        return if orientation.documents.blank?
    
        links << { name: :documents, path: professors_orientation_documents_path(orientation) }
      end

      def meetings_link(links, orientation)
        return if orientation.meetings.blank?
    
        links << { name: :meetings, path: professors_orientation_meetings_path(orientation) }
      end
    
      def edit_link(links, orientation)
        return unless orientation.can_be_edited?
    
        links << { name: :edit, path: edit_professors_orientation_path(orientation) }
      end
    end
    