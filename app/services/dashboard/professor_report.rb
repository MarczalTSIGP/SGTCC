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
    if method == 'tcc_one' || method == 'tcc_two'
      tcc_type = method.split('_').last
      {
        total: orientations.joins(:calendars).where(calendars: { tcc: tcc_type }).count,
        in_progress: orientations.send(method, 'IN_PROGRESS').count,
        approved: orientations.send(method, %w[APPROVED_TCC_ONE APPROVED]).count,
        canceled: orientations.send(method, 'CANCELED').count,
        reproved: orientations.send(method, %w[REPROVED_TCC_ONE REPROVED]).count,
        links: orientations_link(method)
      }
    elsif method == 'current_tcc_one' || method == 'current_tcc_two'
      tcc_type = method.split('_').last
      {
        total: orientations.where(calendars: { tcc: tcc_type }).count,
        in_progress: orientations.send(method, 'IN_PROGRESS').count,
        approved: orientations.send(method, %w[APPROVED_TCC_ONE APPROVED]).count,
        canceled: orientations.send(method, 'CANCELED').count,
        reproved: orientations.send(method, %w[REPROVED_TCC_ONE REPROVED]).count,
        links: orientations_link(method)
      }
    end
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
