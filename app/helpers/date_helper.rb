module DateHelper
  def complete_date(date)
    I18n.localize(date, format: :long)
  end

  def short_date(date)
    I18n.localize(date, format: :short)
  end
end
