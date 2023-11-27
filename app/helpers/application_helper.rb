module ApplicationHelper
  def full_title(page_title = '', base_title = 'SGTCC')
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def namespace
    controller.class.parent.to_s.underscore.downcase
  end

  def icon_to_activity(activity)
    if activity.base_activity_type.send_document?
      return '<i class="fas fa-file-upload pr-2"></i>'.html_safe
    end

    '<i class="fas fa-info pr-3"></i>'.html_safe
  end

  def user_can_access_activity_response
    (current_professor&.responsible? || current_professor&.tcc_one?) &&
      namespace.in?(%w[responsible tcc_one_professors])
  end
end
