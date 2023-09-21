class Supervison::Links::ProfessorsService < Orientations::Links::BaseService
  def setup_links
    details
    activities
    documents
  end

  private

  def details
    @links << { name: :details, path: @route.professors_supervision_path(@orientation) }
  end

  def activities
    @links << {
      name: :activities,
      path: @route.professors_supervision_calendar_activities_path(@orientation,
                                                                   @orientation.current_calendar)
    }
  end

  def documents
    return unless @orientation.documents.empty?

    @links << { name: :documents,
                path: @route.professors_supervision_documents_path(@orientation) }
  end
end
