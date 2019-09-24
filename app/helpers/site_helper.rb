module SiteHelper
  def activity_status_class(activity)
    case activity.status
    when :expired
      'text-decoration-line-through'
    when :ontime
      'font-weight-bold'
    else
      ''
    end
  end
end
