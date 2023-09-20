module TccOneProfessors::OrientationsHelper
    def dropdown_links(orientation)
         links = []
     
         details_link(links, orientation)
         activities_link(links, orientation)
         documents_link(links, orientation)
         
         links
       end
     
       private
     
       def details_link(links, orientation)
         links << { name: :details, path: tcc_one_professors_calendar_orientation_path(
            orientation,
            #  orientation.current_calendar
            @calendar,
         ) 
        }
       end
     
       def activities_link(links, orientation)
         links << {
           name: :activities,
           path: tcc_one_professors_calendar_orientation_activities_path(
             orientation,
            #  orientation.current_calendar
            @calendar
           )
         }
       end
     
       def documents_link(links, orientation)
         return if orientation.documents.blank?
     
         links << { name: :documents, path: tcc_one_professors_calendar_orientation_documents_path(
            orientation,
            #  orientation.current_calendar
            @calendar
           )
         }
       end
end
     