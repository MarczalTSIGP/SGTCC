class Admins::RegistrationsController < Devise::RegistrationsController
  layout 'layouts/admins/application'

  protected

  def after_update_path_for(*)
    edit_admin_registration_path
  end
end
