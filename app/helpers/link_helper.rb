module LinkHelper
  def calendars_link_active?
    new_route = 'calendars/new'
    edit_route = 'calendars/\\d+/edit'
    tcc_routes = 'calendars/tcc_one)|(calendars/tcc_two'

    request.fullpath.match?("(#{tcc_routes})|(#{new_route})|(#{edit_route})")
  end

  def base_activities_link_active?
    request.fullpath.match?('base_activities')
  end

  def orientations_link_active?
    new_route = 'orientations/new'
    edit_route = 'orientations/\\d+/edit'
    tcc_routes = 'orientations/tcc_one)|(orientations/tcc_two'

    request.fullpath.match?("(#{tcc_routes})|(#{new_route})|(#{edit_route})")
  end

  def activities_tcc_link_active?(tcc, namespace)
    is_equal_tcc = @calendar && @calendar.tcc == tcc
    is_equal_tcc && request.fullpath.match?("/#{namespace}/calendars/\\d+/activities")
  end

  def responsible_activities_tcc_one_link_active?
    activities_tcc_link_active?('one', 'responsible')
  end

  def responsible_activities_tcc_two_link_active?
    activities_tcc_link_active?('two', 'responsible')
  end

  def professors_activities_tcc_one_link_active?
    activities_tcc_link_active?('one', 'professors')
  end

  def professors_activities_tcc_two_link_active?
    activities_tcc_link_active?('two', 'professors')
  end

  def orientations_tcc_one_link_active?
    request.fullpath.match?('orientations/current_tcc_one')
  end

  def orientations_tcc_two_link_active?
    request.fullpath.match?('orientations/current_tcc_two')
  end
end
