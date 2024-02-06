class Dashboard::ResponsibleReport
  def report
    {
      professors: professors_report,
      academics: academics_report,
      orientations: orientations_report
    }
  end

  private

  def professors_report
    {
      total: Professor.count,
      available: Professor.available_advisor.count,
      unavailable: Professor.unavailable_advisor.count
    }
  end

  def academics_report
    {
      total: Academic.count,
      orientations: {
        all: { in_progress: Orientation.where(status: %w[IN_PROGRESS APPROVED_TCC_ONE]).count },
        tcc_one: { approved: Orientation.where(status: 'APPROVED_TCC_ONE').count },
        tcc_two: { approved: Orientation.where(status: 'APPROVED').count }
      }
    }
  end

  def orientations_report
    {
      calendar: Calendar.current_by_tcc_one&.year_with_semester,
      ranking: Orientation.professors_ranking,
      calendar_report: calendar_orientations_report,
      tcc_one: orientations_by_tcc('tcc_one'),
      tcc_two: orientations_by_tcc('tcc_two'),
      current_tcc_one: orientations_by_tcc('current_tcc_one'),
      current_tcc_two: orientations_by_tcc('current_tcc_two')
    }
  end

  def calendar_orientations_report
    Orientation.statuses.map do |value, status|
      { label: value.capitalize, data: calendar_orientations_by_status(status) }
    end
  end

  def calendar_orientations_by_status(status)
    groubed_calendars = Calendar.order(:year, :semester).group_by(&:year_with_semester)
    years = []
    total = []

    groubed_calendars.each do |year, calendars|
      years.push(year)
      total.push(orientations_count_by_calendars_and_status(calendars, status))
    end

    { years:, total: }
  end

  def orientations_count_by_calendars_and_status(calendars, status)
    orientations = 0
    calendars.each do |calendar|
      orientations += calendar.orientations.where(status:).count
    end
    orientations
  end

  def orientations_by_tcc_one
    {
      total: Orientation.joins(:calendars).where(calendars: { tcc: 'one' }).count,
      in_progress: Orientation.tcc_one('IN_PROGRESS').count,
      approved: Orientation.tcc_one(%w[APPROVED_TCC_ONE APPROVED]).count,
      canceled: Orientation.tcc_one('CANCELED').count,
      reproved: Orientation.tcc_one(%w[REPROVED_TCC_ONE REPROVED]).count,
      links: orientations_link('tcc_one')
    }
  end

  def orientations_by_tcc_two
    {
      total: Orientation.joins(:calendars).where(calendars: { tcc: 'two' }).count,
      in_progress: Orientation.tcc_two('IN_PROGRESS').count,
      approved: Orientation.tcc_two(%w[APPROVED_TCC_ONE APPROVED]).count,
      canceled: Orientation.tcc_two('CANCELED').count,
      reproved: Orientation.tcc_two(%w[REPROVED_TCC_ONE REPROVED]).count,
      links: orientations_link('tcc_two')
    }
  end

  def orientations_by_tcc(method)
    case method
    when 'tcc_one'
      tcc_orientations('one')
    when 'tcc_two'
      tcc_orientations('two')
    when 'current_tcc_one'
      current_tcc_orientations('one')
    when 'current_tcc_two'
      current_tcc_orientations('two')
    end
  end

  def tcc_orientations(tcc_type)
    total = Orientation.joins(:calendars).where(calendars: { tcc: tcc_type }).count
    in_progress = Orientation.send("tcc_#{tcc_type}", 'IN_PROGRESS').count
    approved = Orientation.send("tcc_#{tcc_type}", %w[APPROVED_TCC_ONE APPROVED]).count
    canceled = Orientation.send("tcc_#{tcc_type}", 'CANCELED').count
    reproved = Orientation.send("tcc_#{tcc_type}", %w[REPROVED_TCC_ONE REPROVED]).count
    links = orientations_link("tcc_#{tcc_type}")
    { total:,
      in_progress:, approved:,
      canceled:, reproved:,
      links: }
  end

  def current_tcc_orientations(tcc_type)
    current_year = Date.current.year, current_semester = Date.current.month <= 6 ? 1 : 2

    { total: count_orientations(tcc_type, current_year, current_semester),
      in_progress: count_orientation_status(tcc_type, current_year, current_semester,
                                            'IN_PROGRESS'),
      approved: count_orientation_status(tcc_type, current_year, current_semester,
                                         %w[APPROVED_TCC_ONE APPROVED]),
      canceled: count_orientation_status(tcc_type, current_year, current_semester, 'CANCELED'),
      reproved: count_orientation_status(tcc_type, current_year, current_semester,
                                         %w[REPROVED_TCC_ONE REPROVED]),
      links: orientations_link("current_tcc_#{tcc_type}") }
  end

  def count_orientations(tcc_type, year, semester)
    Orientation.joins(:calendars).where(calendars: { tcc: tcc_type, year:,
                                                     semester: }).count
  end

  def count_orientation_status(tcc_type, _year, _semester, status)
    Orientation.send("current_tcc_#{tcc_type}", status).count
  end

  def orientations_link(method)
    Orientation.statuses.values.map do |status|
      url_helpers = Rails.application.routes.url_helpers
      url_helpers.send("responsible_orientations_search_#{method}_path", status)
    end
  end
end
