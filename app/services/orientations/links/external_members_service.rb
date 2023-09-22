class Orientations::Links::ExternalMembersService < Orientations::Links::BaseService
  def setup_links
    details
    activities
    documents
  end

  private

  def details
    @links << {
      name: :details,
      path: @route.external_members_supervision_path(@orientation)
    }
  end

  def activities
    @links << {
      name: :activities,
      path: @route.external_members_supervision_calendar_activities_path(
        @orientation, @orientation.current_calendar
      )
    }
  end

  def documents
    return if @orientation.documents.empty?

    @links << {
      name: :documents,
      path: @route.external_members_supervision_documents_path(@orientation)
    }
  end
end
