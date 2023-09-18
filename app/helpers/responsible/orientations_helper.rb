module Responsible::OrientationsHelper
  def dropdown_links(orientation)
    dropdown_links = []

    dropdown_links << details_link(orientation)
    dropdown_links << activities_link(orientation)
    dropdown_links << meetings_link(orientation)
    dropdown_links << documents_link(orientation)
    dropdown_links << divider_link(orientation)
    dropdown_links << edit_link(orientation)
    dropdown_links << delete_link(orientation)

    dropdown_links
  end

  private

  def details_link(orientation)
    { name: :details, path: responsible_orientation_path(orientation) }
  end

  def activities_link(orientation)
    {
      name: :activities,
      path: responsible_orientation_calendar_activities_path(
        orientation,
        orientation.current_calendar
      )
    }
  end

  def meetings_link(orientation)
    return if orientation.meetings.blank?

    { name: :meetings, path: professors_orientation_meetings_path(orientation) }
  end

  def documents_link(orientation)
    return if orientation.documents.blank?

    { name: :documents, path: responsible_orientation_documents_path(orientation) }
  end

  def divider_link(orientation)
    return unless orientation.can_be_edited? || orientation.can_be_destroyed?

    { name: :divider }
  end

  def edit_link(orientation)
    return unless orientation.can_be_edited?

    { name: :edit, path: edit_responsible_orientation_path(orientation) }
  end

  def delete_link(orientation)
    return unless orientation.can_be_destroyed?

    { name: :delete, path: responsible_orientation_path(orientation) }
  end
end
