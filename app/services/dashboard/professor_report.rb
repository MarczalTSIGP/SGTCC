class Dashboard::ProfessorReport
  attr_reader :professor

  def initialize(professor)
    @professor = professor
  end

  def report
    { orientations: orientations_report }
  end

  private

  def orientations_report
    { tcc_one: orientations_by_tcc('tcc_one'),
      tcc_two: orientations_by_tcc('tcc_two') }
  end

  def orientations_by_tcc(method, orientations: @professor.orientations)
    { total: orientations.send(method, orientations.statuses.values).count,
      in_progress: orientations.send(method, 'IN_PROGRESS').count,
      approved: orientations.send(method, 'APPROVED').count,
      renewed: orientations.send(method, 'RENEWED').count,
      canceled: orientations.send(method, 'CANCELED').count,
      links: orientations_link }
  end

  def orientations_link
    Orientation.statuses.values.map do |status|
      url_helpers = Rails.application.routes.url_helpers
      url_helpers.send('professors_orientations_search_history_path', status)
    end
  end
end
