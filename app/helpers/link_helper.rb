module LinkHelper
  def base_activities_link_active?
    request.fullpath.match?('base_activities')
  end

  def history_calendars_link_active?(namespace)
    return true if @calendar.blank?
    route = "(/#{namespace}/calendars/\\d+/activities)"
    calendar_id = @calendar.id
    history_calendar = (calendar_id != Calendar.current_by_tcc_one.id &&
                       calendar_id != Calendar.current_by_tcc_two.id)
    request.fullpath.match?(route) && history_calendar
  end

  def calendars_link_active?(namespace = 'responsible')
    new_route = "/#{namespace}/calendars/new"
    edit_route = "/#{namespace}/calendars/\\d+/edit"
    tcc_routes = "/#{namespace}/calendars/tcc_one|/#{namespace}/calendars/tcc_two"

    match_routes = request.fullpath.match?("(#{tcc_routes})|(#{new_route})|(#{edit_route})")
    match_routes || history_calendars_link_active?(namespace)
  end

  def activities_tcc_link_active?(tcc, namespace)
    is_equal_tcc = @calendar && @calendar.tcc == tcc
    is_equal_tcc && request.fullpath.match?("/#{namespace}/calendars/\\d+/activities")
  end

  def orientations_link_active?(namespace)
    new_route = "/#{namespace}/orientations/new"
    edit_route = "/#{namespace}/orientations/\\d+/edit"
    show_route = "/#{namespace}/orientations/\\d+"
    tcc_routes = "/#{namespace}/orientations/tcc_one|/#{namespace}/orientations/tcc_two"

    request.fullpath.match?("(#{tcc_routes})|(#{show_route})|(#{new_route})|(#{edit_route})")
  end

  def orientations_tcc_one_link_active?(namespace)
    request.fullpath.match?("#{namespace}/orientations/current_tcc_one")
  end

  def orientations_tcc_two_link_active?(namespace)
    request.fullpath.match?("#{namespace}/orientations/current_tcc_two")
  end

  def responsible_orientations_link_active?
    orientations_link_active?('responsible')
  end

  def responsible_orientations_tcc_one_link_active?
    orientations_tcc_one_link_active?('responsible')
  end

  def responsible_orientations_tcc_two_link_active?
    orientations_tcc_two_link_active?('responsible')
  end

  def responsible_current_activities_tcc_one_link_active?
    current_calendar_id = Calendar.current_by_tcc_one.id
    activities_tcc_link_active?('one', 'responsible') && @calendar.id == current_calendar_id
  end

  def responsible_current_activities_tcc_two_link_active?
    current_calendar_id = Calendar.current_by_tcc_two.id
    activities_tcc_link_active?('two', 'responsible') && @calendar.id == current_calendar_id
  end

  def professors_orientations_link_active?
    orientations_link_active?('professors')
  end

  def tcc_one_professors_activities_tcc_one_link_active?
    activities_tcc_link_active?('one', 'tcc_one_professors')
  end

  def tcc_one_professors_orientations_tcc_one_link_active?
    orientations_path = '/tcc_one_professors/orientations'
    calendar_orientations_path = '/tcc_one_professors/calendars/\\d+/orientations'
    request.fullpath.match?("(#{orientations_path})|(#{calendar_orientations_path})")
  end

  def calendar_tcc_one_title
    Calendar.current_by_tcc_one&.year_with_semester
  end
end
