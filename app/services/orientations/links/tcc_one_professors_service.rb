class Orientations::Links::TccOneProfessorsService < Orientations::Links::BaseService
  def setup_links
    details
    activities
    documents
  end

  private

  def details
    @links << {
      name: :details,
      path: @route.tcc_one_professors_calendar_orientation_path(
        @orientation.current_calendar, @orientation
      )
    }
  end

  def activities
    @links << {
      name: :activities,
      path: @route.tcc_one_professors_orientation_calendar_activities_path(
        @orientation, @orientation.current_calendar
      )
    }
  end

  def documents
    return if @orientation.documents.empty?

    @links << {
      name: :documents,
      path: @route.tcc_one_professors_calendar_orientation_documents_path(
        @orientation.current_calendar, @orientation
      )
    }
  end
end
