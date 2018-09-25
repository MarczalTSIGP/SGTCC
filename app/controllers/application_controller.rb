class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protected

  def layout_by_resource
    return 'layouts/session' if devise_controller?

    'layouts/application'
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    new_professor_session_path
  end
end
