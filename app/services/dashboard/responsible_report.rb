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
    { tcc_one: orientations_tcc_one_report,
      tcc_two: orientations_tcc_two_report,
      current_tcc_one: orientations_current_tcc_one_report,
      current_tcc_two: orientations_current_tcc_two_report }
  end

  def orientations_tcc_one_report
    { in_progress: Orientation.tcc_one('IN_PROGRESS').count,
      approved: Orientation.tcc_one('APPROVED').count,
      renewed: Orientation.tcc_one('RENEWED').count / 2,
      canceled: Orientation.tcc_one('CANCELED').count }
  end

  def orientations_tcc_two_report
    { in_progress: Orientation.tcc_two('IN_PROGRESS').count,
      approved: Orientation.tcc_two('APPROVED').count,
      renewed: Orientation.tcc_two('RENEWED').count / 2,
      canceled: Orientation.tcc_two('CANCELED').count }
  end

  def orientations_current_tcc_one_report
    { in_progress: Orientation.current_tcc_one('IN_PROGRESS').count,
      approved: Orientation.current_tcc_one('APPROVED').count,
      renewed: Orientation.current_tcc_one('RENEWED').count / 2,
      canceled: Orientation.current_tcc_one('CANCELED').count }
  end

  def orientations_current_tcc_two_report
    { in_progress: Orientation.current_tcc_two('IN_PROGRESS').count,
      approved: Orientation.current_tcc_two('APPROVED').count,
      renewed: Orientation.current_tcc_two('RENEWED').count / 2,
      canceled: Orientation.current_tcc_two('CANCELED').count }
  end
end
