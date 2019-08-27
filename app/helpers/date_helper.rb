module DateHelper
  def complete_date(date)
    I18n.localize(date, format: :long)
  end

  def short_date(date)
    I18n.localize(date, format: :short)
  end

  def document_date(date)
    I18n.localize(date, format: :document)
  end

  def datetime(date)
    I18n.localize(date, format: :datetime)
  end
end
