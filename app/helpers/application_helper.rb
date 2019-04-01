module ApplicationHelper
  def full_title(page_title = '', base_title = 'SGTCC')
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def complete_date(date)
    I18n.localize(date, format: :long)
  end

  def short_date(date)
    I18n.localize(date, format: :short)
  end
end
