class Professors::RegistrationsController < Devise::RegistrationsController
  layout 'layouts/professors/application'

  protected

  def after_update_path_for(_resource)
    edit_professor_registration_path
  end
end
