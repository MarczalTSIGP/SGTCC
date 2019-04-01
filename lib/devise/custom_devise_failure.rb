class CustomDeviseFailure < Devise::FailureApp
  def redirect_url
    send("new_#{warden_options[:scope]}_session_url")
  end
end
