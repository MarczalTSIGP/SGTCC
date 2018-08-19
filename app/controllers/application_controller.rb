class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protected

  def layout_by_resource
    return 'layouts/session' if devise_controller?

    'layouts/application'
  end
end
