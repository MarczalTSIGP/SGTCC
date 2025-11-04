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

  def tcc_report?(orientations_report)
    tcc_one_report?(orientations_report) || tcc_two_report?(orientations_report)
  end

  def tcc_one_report?(orientations_report)
    orientations_report[:tcc_one][:total].positive?
  end

  def tcc_two_report?(orientations_report)
    orientations_report[:tcc_two][:total].positive?
  end

  def both_tcc_report?(orientations_report)
    tcc_one_report?(orientations_report) && tcc_two_report?(orientations_report)
  end

  def card_responsive_class(orientations_report)
    both_tcc_report?(orientations_report) ? 'col-md-6' : 'col-12'
  end
end
