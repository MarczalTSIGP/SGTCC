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
    { tcc_one: orientations_by_tcc('tcc_one'),
      tcc_two: orientations_by_tcc('tcc_two'),
      current_tcc_one: orientations_by_tcc('current_tcc_one'),
      current_tcc_two: orientations_by_tcc('current_tcc_two') }
  end

  def orientations_by_tcc(method)
    { in_progress: Orientation.send(method, 'IN_PROGRESS').count,
      approved: Orientation.send(method, 'APPROVED').count,
      renewed: Orientation.send(method, 'RENEWED').count / 2,
      canceled: Orientation.send(method, 'CANCELED').count }
  end
end
