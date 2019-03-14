class CustomDeviseFailure < Devise::FailureApp
  def redirect_url
    if warden_options[:scope] == :academic
      new_academics_session_url
    elsif warden_options[:scope] == :professor
      new_responsible_session_url
    else
      new_external_members_session_url
    end
  end
end
