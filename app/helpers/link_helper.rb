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

  def activities_tcc_link_active?(tcc)
    is_equal_tcc = @calendar && @calendar.tcc == tcc
    is_equal_tcc && request.fullpath.match?('activities')
  end

  def activities_tcc_one_link_active?
    activities_tcc_link_active?('one')
  end

  def activities_tcc_two_link_active?
    activities_tcc_link_active?('two')
  end
end
