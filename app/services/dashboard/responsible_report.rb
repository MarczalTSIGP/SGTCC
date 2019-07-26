class Dashboard::ResponsibleReport
  def report
    professors_report
  end

  private

  def professors_report
    { professors: { total: Professor.count,
                    available: Professor.available_advisor.count,
                    unavailable: Professor.unavailable_advisor.count } }
  end
end
