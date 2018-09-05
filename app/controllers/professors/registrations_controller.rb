class Professors::RegistrationsController < Devise::RegistrationsController
  layout 'layouts/session'

  protected
  def after_update_path_for(resource)
    edit_professor_registration_path
  end
end


