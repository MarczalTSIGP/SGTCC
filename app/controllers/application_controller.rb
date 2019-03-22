class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protected

  def layout_by_resource
    return 'layouts/sessions/session' if devise_controller?

    'layouts/application'
  end

  def after_sign_in_path_for(*)
    if resource_name == :professor
      return responsible_root_path if current_professor.role?('Professor responsável')
    end
    send("#{resource_name.to_s.pluralize}_root_path")
  end

  private

  def after_sign_out_path_for(*)
    send("new_#{resource_name}_session_path")
  end
end
