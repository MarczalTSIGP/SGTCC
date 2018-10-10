class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protected

  def layout_by_resource
    return 'layouts/sessions/session' if devise_controller?

    'layouts/application'
  end

  def after_sign_in_path_for(resource)
    return professors_root_path if resource.is_a?(Professor)

    root_path
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    new_professor_session_path
  end
end
