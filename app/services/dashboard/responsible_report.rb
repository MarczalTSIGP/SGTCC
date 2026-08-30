class Dashboard::ResponsibleReport
  def report
    {
      professors: professors_report,
      academics: academics_report,
      orientations: orientations_report
    }
  end

  private

  def professors_report
    {
      total: Professor.count,
      available: Professor.available_advisor.count,
      unavailable: Professor.unavailable_advisor.count
    }
  end

  def academics_report
    {
      total: Academic.count,
      orientations: {
        all: { in_progress: Orientation.where(status: %w[IN_PROGRESS APPROVED_TCC_ONE]).count },
        tcc_one: { approved: Orientation.where(status: 'APPROVED_TCC_ONE').count },
        tcc_two: { approved: Orientation.where(status: 'APPROVED').count }
      }
    }
  end

  # TODO: Refactor this method
  # CODE SMELL: This method is horrible, should be refactor
  def orientations_report
    {
      calendar: Calendar.current_by_tcc_one&.year_with_semester,
      ranking: Dashboard::ProfessorsRankingReport.call,
      calendar_report: calendar_orientations_report,
      tcc_one: orientations_by_tcc_one,
      tcc_two: orientations_by_tcc_two,
      current_tcc_one: current_tcc_one_orientations,
      current_tcc_two: current_tcc_two_orientations
    }
  end

  def calendar_orientations_report
    Orientation.statuses.map do |value, status|
      { label: value.capitalize, data: calendar_orientations_by_status(status) }
    end
  end

  def calendar_orientations_by_status(status)
    groubed_calendars = Calendar.order(:year, :semester).group_by(&:year_with_semester)
    years = []
    total = []

    groubed_calendars.each do |year, calendars|
      years.push(year)
      total.push(orientations_count_by_calendars_and_status(calendars, status))
    end

    { years:, total: }
  end

  # Known placeholder: always returns 0. Implementing the real count per calendar/status
  # is a functional change outside the scope of this refactoring (REF-08).
  # The dashboard's calendar_report chart currently displays all-zero series silently.
  def orientations_count_by_calendars_and_status(_calendars, _status)
    0
  end

  # rubocop:disable Metrics/AbcSize
  # TODO: Refactor this method
  # CODE SMELL: This method is horrible, should be refactor
  def orientations_by_tcc_one
    orientations = Orientation.joins(:calendars).distinct.where(calendars: { tcc: :one })
                              .select(&:tcc_one?)
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
    orientations = Orientation.joins(:calendars).distinct.where(calendars: { tcc: :two })
    {
      total: orientations.count,
      in_progress: orientations.tcc_two('APPROVED_TCC_ONE').count,
      approved: orientations.tcc_two('APPROVED').count,
      canceled: orientations.tcc_two('CANCELED').count,
      reproved: orientations.tcc_two('REPROVED').count,
      links: orientations_link('tcc_two')
    }
  end
  # rubocop:enable Metrics/AbcSize

  def current_tcc_one_orientations
    current_year, current_semester = current_period

    { total: count_orientations('one', current_year, current_semester),
      in_progress: count_orientation_status('one', current_year, current_semester,
                                            'IN_PROGRESS'),
      approved: count_orientation_status('one', current_year, current_semester,
                                         'APPROVED_TCC_ONE'),
      canceled: count_orientation_status('one', current_year, current_semester, 'CANCELED'),
      reproved: count_orientation_status('one', current_year, current_semester,
                                         'REPROVED_TCC_ONE'),
      links: orientations_link('current_tcc_one') }
  end

  def current_tcc_two_orientations
    tcc_type = 'two'
    current_year, current_semester = current_period

    { total: count_orientations(tcc_type, current_year, current_semester),
      in_progress: count_orientation_status(tcc_type, current_year, current_semester,
                                            'IN_PROGRESS'),
      approved: count_orientation_status(tcc_type, current_year, current_semester, 'APPROVED'),
      canceled: count_orientation_status(tcc_type, current_year, current_semester, 'CANCELED'),
      reproved: count_orientation_status(tcc_type, current_year, current_semester, 'REPROVED'),
      links: orientations_link("current_tcc_#{tcc_type}") }
  end

  def count_orientations(tcc_type, year, semester)
    Orientation.joins(:calendars).where(calendars: { tcc: tcc_type.to_sym, year:,
                                                     semester: }).count
  end

  def current_period
    [Calendar.current_year, Calendar.current_semester]
  end

  def count_orientation_status(tcc_type, _year, _semester, status)
    Orientation.send("current_tcc_#{tcc_type}", status).count
  end

  def orientations_link(method)
    Orientation.statuses.values.map do |status|
      url_helpers = Rails.application.routes.url_helpers
      url_helpers.send("responsible_orientations_search_#{method}_path", status)
    end
  end
end
