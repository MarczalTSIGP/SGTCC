module ApplicationHelper

  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning',
      notice: 'alert-info' }[flash_type.to_sym] || flash_type.to_s
  end

  def full_title(page_title = '', base_title = 'SGTCC')
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
