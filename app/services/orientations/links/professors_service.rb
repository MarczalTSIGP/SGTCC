class Orientations::Links::ProfessorsService < Orientations::Links::BaseService
  def setup_links
    details
    activities
    documents
    meetings
    edit
  end

  private

  def details
    @links << { name: :details, path: @route.professors_orientation_path(@orientation) }
  end

  def activities
    @links << {
      name: :activities,
      path: @route.professors_orientation_calendar_activities_path(@orientation,
                                                                   @orientation.current_calendar)
    }
  end

  def documents
    return if @orientation.documents.empty?

    @links << { name: :documents,
                path: @route.professors_orientation_documents_path(@orientation) }
  end

  def meetings
    return if @orientation.meetings.blank?

    @links << { name: :meetings,
                path: @route.professors_orientation_meetings_path(@orientation) }
  end

  def edit
    return unless @orientation.can_be_edited?

    @links << { name: :edit, path: @route.edit_professors_orientation_path(@orientation) }
  end
end
