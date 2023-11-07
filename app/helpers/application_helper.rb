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

  def activity_count_sended(activity)
    if activity.base_activity_type.send_document?
      return "#{activity.response_summary.count} \
              de #{activity.response_summary.total} \
              #{Activity.human_attribute_name('sent')}s"
    end
    '-'
  end
end
