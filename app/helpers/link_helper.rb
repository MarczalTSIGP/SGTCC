module LinkHelper
  def active_activities_tcc_one_link
    is_tcc_one = @calendar && @calendar.tcc == 'one'
    is_tcc_one && request.fullpath.match('activity')
  end

  def active_activities_tcc_two_link
    is_tcc_two = @calendar && @calendar.tcc == 'two'
    is_tcc_two && request.fullpath.match('activity')
  end
end
