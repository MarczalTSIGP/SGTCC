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
    { tcc_one: orientations_by_tcc_one,
      tcc_two: orientations_by_tcc_two }
  end

  # rubocop:disable Metrics/AbcSize
  # TODO: Refactor this method
  # CODE SMELL: This method is horrible, should be refactor
  def orientations_by_tcc_one
    orientations = @professor.orientations.joins(:calendars)
                             .distinct.where(calendars: { tcc: 'one' }).select(&:tcc_one?)
    {
      total: orientations.count,
      in_progress: orientations.count { |o| o.status.eql?('em andamento') },
      approved: orientations.count { |o| o.status.eql?('Aprovada em TCC 1') },
      canceled: orientations.count { |o| o.status.eql?('cancelada') },
      reproved: orientations.count { |o| o.status.eql?('Reprovada em TCC 1') },
      links: orientations_link('tcc_one')
    }
  end

  # TODO: Refactor this method
  # CODE SMELL: This method is horrible, should be refactor
  def orientations_by_tcc_two
    orientations = @professor.orientations
    orientations = orientations.joins(:calendars).distinct.where(calendars: { tcc: 'two' })
    {
      total: orientations.select(&:tcc_two?).count,
      in_progress: orientations.tcc_two('APPROVED_TCC_ONE').count,
      approved: orientations.tcc_two('APPROVED').count,
      canceled: orientations.tcc_two('CANCELED').count,
      reproved: orientations.tcc_two('REPROVED').count,
      links: orientations_link('tcc_two')
    }
  end
  # rubocop:enable Metrics/AbcSize

  # def calculate_orientations(method)
  #   return {} unless valid_method?(method)

  #   tcc_type = method.split('_').last

  #   progress = tcc_type.eql?('one') ? 'IN_PROGRESS' : 'APPROVED_TCC_ONE'
  #   approved = tcc_type.eql?('one') ? 'APPROVED_TCC_ONE' : 'APPROVED'
  #   reproved = tcc_type.eql?('one') ? 'REPROVED_TCC_ONE' : 'REPROVED'

  #   {
  #     total: total_orientations(tcc_type),
  #     in_progress: count_orientations(method, progress),
  #     approved: count_orientations(method, approved),
  #     canceled: count_orientations(method, 'CANCELED'),
  #     reproved: count_orientations(method, reproved),
  #     links: orientations_link(method)
  #   }
  # end

  # def valid_method?(method)
  #   %w[tcc_one tcc_two current_tcc_one current_tcc_two].include?(method)
  # end

  # def total_orientations(tcc_type)
  #   orientations = @professor.orientations
  #   .joins(:calendars).distinct.where(calendars: { tcc: tcc_type })
  #   orientations.select { |o| o.send("tcc_#{tcc_type}?") }.count
  # end

  # def count_orientations(method, status)
  #   @professor.orientations.send(method, status).count
  # end

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
