module LinkHelper
  def active_calendars_link
    edit_calendar_path = "/responsible/calendars/\d{1}/edit"

    tccs_routes = "#{responsible_calendars_tcc_one_path})$|^(#{responsible_calendars_tcc_two_path}"
    new_and_edit_routes = "(#{new_responsible_calendar_path})|(#{edit_calendar_path})"

    request.fullpath.match?("^(#{tccs_routes})$|#{new_and_edit_routes}")
  end

  def active_activities_tcc_one_link
    is_tcc_one = @calendar && @calendar.tcc == 'one'
    is_tcc_one && request.fullpath.match?('activities')
  end

  def active_activities_tcc_two_link
    is_tcc_two = @calendar && @calendar.tcc == 'two'
    is_tcc_two && request.fullpath.match?('activities')
  end
end
