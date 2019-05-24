module ActiveLinkHelper
  def match_link?(url)
    request.fullpath.match?(url)
  end

  def calendars_link_active?(namespace = 'responsible')
    regex = "^\/#{namespace}\/calendars(\/(tcc_one|tcc_two|new|edit))?$"
    match_link?(regex) || calendars_history_active_link?(namespace)
  end

  def calendars_history_active_link?(namespace)
    route = "\/#{namespace}\/calendars\/\\d+/activities"
    match_link?(route) && calendar_from_history?
  end

  def calendar_from_history?
    current_calendar_tcc_one = Calendar.current_by_tcc_one
    current_calendar_tcc_two = Calendar.current_by_tcc_two
    if @calendar.blank? || current_calendar_tcc_one.blank? || current_calendar_tcc_two.blank?
      return false
    end
    calendar_id = @calendar.id
    calendar_id != current_calendar_tcc_one.id && calendar_id != current_calendar_tcc_two.id
  end

  def orientations_link_active?(namespace = 'responsible')
    regex = "^\/#{namespace}\/orientations(\/(tcc_one|tcc_two|new|edit|\\d+))?$"
    match_link?(regex)
  end

  def orientations_tcc_one_link_active?(namespace = 'responsible')
    match_link?("#{namespace}/orientations/current_tcc_one")
  end

  def orientations_tcc_two_link_active?(namespace = 'responsible')
    match_link?("#{namespace}/orientations/current_tcc_two")
  end

  def activities_tcc_link_active?(tcc_type = 'one', namespace = 'responsible')
    is_equal_tcc_type = @calendar && @calendar.tcc == tcc_type
    match_link?("/#{namespace}/calendars/\\d+/activities") && is_equal_tcc_type
  end

  def calendar_equal_current_calendar_tcc_one?
    current_calendar_tcc_one = Calendar.current_by_tcc_one
    return true if @calendar.blank? || current_calendar_tcc_one.blank?
    @calendar.id == current_calendar_tcc_one.id
  end

  def calendar_equal_current_calendar_tcc_two?
    current_calendar_tcc_two = Calendar.current_by_tcc_two
    return true if @calendar.blank? || current_calendar_tcc_two.blank?
    @calendar.id == current_calendar_tcc_two.id
  end

  def responsible_current_activities_tcc_one_link_active?
    activities_tcc_link_active? && calendar_equal_current_calendar_tcc_one?
  end

  def responsible_current_activities_tcc_two_link_active?
    activities_tcc_link_active?('two') && calendar_equal_current_calendar_tcc_two?
  end

  def responsible_base_activities_link_active?
    match_link?('/responsible/base_activities')
  end

  def academics_calendars_link_active?
    index_route = '/academics/calendars'
    calendars_history_active_link?('academics') || match_link?("^(#{index_route})$")
  end

  def academics_activities_tcc_one_link_active?
    activities_tcc_link_active?('one', 'academics') && calendar_equal_current_calendar_tcc_one?
  end

  def academics_activities_tcc_two_link_active?
    activities_tcc_link_active?('two', 'academics') && calendar_equal_current_calendar_tcc_two?
  end

  def supervisions_tcc_one_or_two_link_active?
    tcc_routes = '/supervisions/tcc_one|/supervisions/tcc_two'
    request.fullpath.match?("(#{tcc_routes})")
  end

  def supervisions_link_active?
    return true if supervisions_tcc_one_or_two_link_active?
    show_route = '/supervisions/\\d+'
    request.fullpath.match?("(#{show_route})")
  end

  def supervisions_history_link_active?
    request.fullpath.match?('/supervisions/history')
  end

  def professors_orientations_link_active?
    orientations_link_active?('professors') &&
      (calendar_equal_current_calendar_tcc_one? ||
      calendar_equal_current_calendar_tcc_two?)
  end

  def professors_orientations_history_link_active?
    history = request.fullpath.match?('/professors/orientations/history')
    current_calendar = !(calendar_equal_current_calendar_tcc_one? ||
                        calendar_equal_current_calendar_tcc_two?)
    history || (request.fullpath.match?('/professors/orientations/\\d+') && current_calendar)
  end

  def tcc_one_professors_activities_tcc_one_link_active?
    activities_tcc_link_active?('one', 'tcc_one_professors') &&
      calendar_equal_current_calendar_tcc_one?
  end

  def tcc_one_professors_orientations_tcc_one_link_active?
    orientations_path = '/tcc_one_professors/orientations'
    calendar_orientations_path = '/tcc_one_professors/calendars/\\d+/orientations'
    request.fullpath.match?("(#{orientations_path})|(#{calendar_orientations_path})")
  end

  def tcc_one_professors_calendars_link_active?
    calendars_link_active?('tcc_one_professors')
  end
end
