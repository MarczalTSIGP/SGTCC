class Dashboard::ResponsibleReport
  def report
    { professors: professors_report,
      academics: academics_report,
      orientations: orientations_report }
  end

  private

  def professors_report
    { total: Professor.count,
      available: Professor.available_advisor.count,
      unavailable: Professor.unavailable_advisor.count }
  end

  def academics_report
    { total: Academic.count,
      orientations: {
        all: {
          in_progress: Orientation.where(status: %w[IN_PROGRESS APPROVED_TCC_ONE]).count
        },
        tcc_one: {
          approved: Orientation.where(status: 'APPROVED_TCC_ONE').count
        },
        tcc_two: {
          approved: Orientation.where(status: 'APPROVED').count
        }
      } }
  end

  def orientations_report
    { calendar: Calendar.current_by_tcc_one&.year_with_semester,
      ranking: Orientation.professors_ranking,
      calendar_report: calendar_orientations_report,
      tcc_one: orientations_by_tcc('tcc_one'),
      tcc_two: orientations_by_tcc_two,
      current_tcc_one: orientations_by_tcc('current_tcc_one'),
      current_tcc_two: orientations_by_tcc('current_tcc_two') }
  end

  def calendar_orientations_report
    Orientation.statuses.map do |value, status|
      { label: value.capitalize, data: calendar_orientations_by_status(status) }
    end
  end

  def calendar_orientations_by_status(status)
    calendars = Calendar.order(:year, :semester)
    years = []
    total = []

    calendars.each do |calendar|
      years.push(calendar.year_with_semester)
      total.push(calendar.orientations.where(status: status).count)
    end

    { years: years, total: total }
  end

  def orientations_by_tcc_one
    { total: Orientation.joins(:calendars).where(calendars: { tcc: 'one' }).count,
      in_progress: Orientation.tcc_one('IN_PROGRESS').count,
      approved: Orientation.tcc_one(%w[APPROVED_TCC_ONE APPROVED]).count,
      canceled: Orientation.tcc_one('CANCELED').count,
      reproved: Orientation.tcc_one(%w[REPROVED_TCC_ONE REPROVED]).count,
      links: orientations_link('tcc_one') }
  end

  def orientations_by_tcc_two
    { total: Orientation.joins(:calendars).where(calendars: { tcc: 'two' }).count,
      in_progress: Orientation.tcc_two('IN_PROGRESS').count,
      approved: Orientation.tcc_two('APPROVED').count,
      canceled: Orientation.tcc_two('CANCELED').count,
      reproved: Orientation.tcc_two('REPROVED').count,
      links: orientations_link('tcc_two') }
  end

  def orientations_by_tcc(method)
  if method == 'tcc_one'
    {
      total: Orientation.joins(:calendars).where(calendars: { tcc: 'one' }).count,
      in_progress: Orientation.tcc_one('IN_PROGRESS').count,
      approved: Orientation.tcc_one(%w[APPROVED_TCC_ONE APPROVED]).count,
      canceled: Orientation.tcc_one('CANCELED').count,
      reproved: Orientation.tcc_one(%w[REPROVED_TCC_ONE REPROVED]).count,
      links: orientations_link('tcc_one')
    }
  elsif method == 'tcc_two'
    {
      total: Orientation.joins(:calendars).where(calendars: { tcc: 'two' }).count,
      in_progress: Orientation.tcc_two('IN_PROGRESS').count,
      approved: Orientation.tcc_two('APPROVED').count,
      canceled: Orientation.tcc_two('CANCELED').count,
      reproved: Orientation.tcc_two('REPROVED').count,
      links: orientations_link('tcc_two')
    }
  else
  end
end

def orientations_link(method)
    Orientation.statuses.values.map do |status|
      url_helpers = Rails.application.routes.url_helpers
      url_helpers.send("responsible_orientations_search_#{method}_path", status)
    end
  end
end
