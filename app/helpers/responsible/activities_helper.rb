module Responsible::ActivitiesHelper
  def display_activities_options
    hide_fields
  end

  def hide_fields
    if @base_activity.base_activity_type.nil? || @base_activity.base_activity_type.info?
      'd-none'
    end
  end
end
