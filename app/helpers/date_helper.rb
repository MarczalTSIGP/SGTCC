module DateHelper
  def complete_date(date)
    I18n.l(date, format: :long)
  end

  def short_date(date)
    I18n.l(date, format: :short)
  end

  def document_date(date)
    I18n.l(date, format: :document)
  end

  def datetime(date)
    I18n.l(date, format: :datetime)
  end

  def long_date(date)
    I18n.l(date, format: :long_without_time)
  end
end
