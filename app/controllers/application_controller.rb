class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protected

  def layout_by_resource
    return 'layouts/sessions/session' if devise_controller?

    'layouts/application'
  end

  def after_sign_in_path_for(*)
    if resource_name == :professor
      responsible_root_path
    elsif resource_name == :academic
      academics_root_path
    else
      external_members_root_path
    end
  end

  private

  def after_sign_out_path_for(*)
    if resource_name == :professor
      new_responsible_session_path
    elsif resource_name == :academic
      new_academics_session_path
    else
      new_external_members_session_path
    end
  end
end
