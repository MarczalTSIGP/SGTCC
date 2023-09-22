class Orientations::Links::ResponsibleService < Orientations::Links::BaseService
  def setup_links
    details
    activities
    meetings
    documents
    divider
    edit
    destroy
  end

  private

  def details
    @links << { name: :details, path: @route.responsible_orientation_path(@orientation) }
  end

  def activities
    @links << {
      name: :activities,
      path: @route.responsible_orientation_calendar_activities_path(@orientation,
                                                                    @orientation.current_calendar)
    }
  end

  def meetings
    return if @orientation.meetings.blank?

    @links << { name: :meetings, path: @route.professors_orientation_meetings_path(@orientation) }
  end

  def documents
    return if @orientation.documents.empty?

    @links << { name: :documents,
                path: @route.responsible_orientation_documents_path(@orientation) }
  end

  def divider
    @links << { name: :divider } if @orientation.can_be_edited? || @orientation.can_be_destroyed?
  end

  def edit
    return unless @orientation.can_be_edited?

    @links << { name: :edit, path: @route.edit_responsible_orientation_path(@orientation) }
  end

  def destroy
    return unless @orientation.can_be_destroyed?

    @links << { name: :delete, path: @route.responsible_orientation_path(@orientation) }
  end
end
