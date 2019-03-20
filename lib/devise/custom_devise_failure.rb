class CustomDeviseFailure < Devise::FailureApp
  def redirect_url
    resource_name = warden_options[:scope]
    return new_responsible_session_url if resource_name == :professor
    send("new_#{resource_name.to_s.pluralize}_session_url")
  end
end
