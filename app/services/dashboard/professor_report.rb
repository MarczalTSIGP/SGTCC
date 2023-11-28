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
    { tcc_one: calculate_orientations('tcc_one'),
      tcc_two: calculate_orientations('tcc_two') }
  end

  def calculate_orientations(method)
    return {} unless valid_method?(method)

    tcc_type = method.split('_').last
    {
      total: total_orientations(tcc_type),
      in_progress: count_orientations(method, 'IN_PROGRESS'),
      approved: count_orientations(method, %w[APPROVED_TCC_ONE APPROVED]),
      canceled: count_orientations(method, 'CANCELED'),
      reproved: count_orientations(method, %w[REPROVED_TCC_ONE REPROVED]),
      links: orientations_link(method)
    }
  end

  def valid_method?(method)
    %w[tcc_one tcc_two current_tcc_one current_tcc_two].include?(method)
  end

  def total_orientations(tcc_type)
    @professor.orientations.joins(:calendars).where(calendars: { tcc: tcc_type }).count
  end

  def count_orientations(method, status)
    @professor.orientations.send(method, status).count
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
