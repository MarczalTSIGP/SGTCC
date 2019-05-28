module TitleHelper
  def current_calendar_title
    "#{Calendar.current_year}/#{Calendar.current_semester}"
  end
end
