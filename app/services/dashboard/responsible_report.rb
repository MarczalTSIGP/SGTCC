class Dashboard::ResponsibleReport
  def report
    { professors: professors_report,
      orientations: orientations_report }
  end

  private

  def professors_report
    { total: Professor.count,
      available: Professor.available_advisor.count,
      unavailable: Professor.unavailable_advisor.count }
  end

  def orientations_report
    { calendar: Calendar.current_by_tcc_one&.year_with_semester,
      ranking: Orientation.professors_ranking,
      tcc_one: orientations_by_tcc('tcc_one'),
      tcc_two: orientations_by_tcc('tcc_two'),
      current_tcc_one: orientations_by_tcc('current_tcc_one'),
      current_tcc_two: orientations_by_tcc('current_tcc_two') }
  end

  def orientations_by_tcc(method)
    { total: Orientation.send(method, Orientation.statuses.values).count,
      in_progress: Orientation.send(method, 'IN_PROGRESS').count,
      approved: Orientation.send(method, 'APPROVED').count,
      renewed: Orientation.send(method, 'RENEWED').count,
      canceled: Orientation.send(method, 'CANCELED').count,
      links: orientations_link(method) }
  end

  def orientations_link(method)
    Orientation.statuses.values.map do |status|
      url_helpers = Rails.application.routes.url_helpers
      url_helpers.send("responsible_orientations_search_#{method}_path", status)
    end
  end
end
