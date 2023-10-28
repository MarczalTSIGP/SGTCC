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
        all: { in_progress: academics_orientations('IN_PROGRESS') },
        tcc_one: { approved: academics_orientations('APPROVED', 1) },
        tcc_two: { approved: academics_orientations('APPROVED', 2) }
      } }
  end

  def academics_orientations(status, tcc = nil)
    conditions = { status: status }
    conditions['calendars'] = { tcc: tcc } if tcc.present?
    Academic.joins(orientations: [:calendars])
            .where(orientations: conditions).size
  end

  def orientations_report
    { calendar: Calendar.current_by_tcc_one&.year_with_semester,
      ranking: Orientation.professors_ranking,
      calendar_report: calendar_orientations_report,
      tcc_one: orientations_by_tcc('tcc_one'),
      tcc_two: orientations_by_tcc('tcc_two'),
      current_tcc_one: orientations_by_tcc('current_tcc_one'),
      current_tcc_two: orientations_by_tcc('current_tcc_two') }
  end

  def calendar_orientations_report
    Orientation.statuses.sort.map do |value, status|
      { label: value.capitalize, data: Calendar.orientations_report_by_status(status) }
    end
  end

  def orientations_by_tcc(method)
    { total: Orientation.send(method, Orientation.statuses.values).count,
      in_progress: Orientation.send(method, 'IN_PROGRESS').count,
      approved: Orientation.send(method, 'APPROVED').count,
      canceled: Orientation.send(method, 'CANCELED').count,
      reproved: Orientation.send(method, 'REPROVED').count,
      reproved_tcc_one: Orientation.send(method, 'REPROVED_TCC_ONE').count,
      links: orientations_link(method) }
  end

  def orientations_link(method)
    Orientation.statuses.values.map do |status|
      url_helpers = Rails.application.routes.url_helpers
      url_helpers.send("responsible_orientations_search_#{method}_path", status)
    end
  end
end
