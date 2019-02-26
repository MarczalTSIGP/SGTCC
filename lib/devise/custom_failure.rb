class CustomFailure < Devise::FailureApp
  def redirect_url
    new_responsible_session_url
  end
end
