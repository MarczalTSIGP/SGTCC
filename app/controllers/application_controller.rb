class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protected

  def layout_by_resource
    return 'layouts/sessions/session' if devise_controller?

    'layouts/application'
  end

  def after_sign_in_path_for(*)
    professors_root_path
  end

  private

  def after_sign_out_path_for(_resource_or_scope)
    new_professor_session_path
  end
end
