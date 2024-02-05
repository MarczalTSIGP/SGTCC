module Professors::DashboardHelper
  def link_to_submission(submission, options = {})
    calendar = submission.activity.calendar
    activity = submission.activity
    academic = submission.academic
    orientation = academic.orientations
                          .joins(:calendars)
                          .find_by(calendars: { year: calendar.year, semester: calendar.semester })

    link_to(academic.name, professors_orientation_calendar_activity_path(
                             orientation, calendar, activity
                           ), class: options[:class])
  end
end
