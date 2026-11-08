class Dashboard::ProfessorPresenter
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
    { tcc_one: orientations_by_tcc_one,
      tcc_two: orientations_by_tcc_two }
  end

  # TODO: Refactor this method
  # CODE SMELL: This method is horrible, should be refactor
  def orientations_by_tcc_one
    orientations = @professor.orientations.joins(:calendars)
                             .distinct.where(calendars: { tcc: :one }).select(&:tcc_one?)
    {
      total: orientations.count,
      in_progress: orientations.count(&:in_progress?),
      approved: orientations.count(&:approved_tcc_one?),
      canceled: orientations.count(&:canceled?),
      reproved: orientations.count(&:reproved_tcc_one?),
      links: orientations_link('tcc_one')
    }
  end

  # TODO: Refactor this method
  # CODE SMELL: This method is horrible, should be refactor
  def orientations_by_tcc_two
    orientations = @professor.orientations
    orientations = orientations.joins(:calendars).distinct.where(calendars: { tcc: :two })
    {
      total: orientations.select(&:tcc_two?).count,
      in_progress: orientations.tcc_two('APPROVED_TCC_ONE').count,
      approved: orientations.tcc_two('APPROVED').count,
      canceled: orientations.tcc_two('CANCELED').count,
      reproved: orientations.tcc_two('REPROVED').count,
      links: orientations_link('tcc_two')
    }
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
