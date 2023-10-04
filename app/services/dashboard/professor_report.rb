class Dashboard::ProfessorReport
  attr_reader :professor, :current_professor

  def initialize(current_professor, professor)
    @current_professor = current_professor
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
      canceled: orientations.send(method, 'CANCELED').count,
      links: orientations_link(method) }
  end

  def orientations_link(method, url: 'professors_orientations_search_history_path', params_url: {})
    if @current_professor.responsible?
      url = "responsible_professor_orientations_search_#{method}_path"
      params_url = { id: @professor.id }
    end

    Orientation.statuses.values.map do |status|
      params_url['status'] = status
      url_helpers = Rails.application.routes.url_helpers
      url_helpers.send(url, params_url)
    end
  end
end
