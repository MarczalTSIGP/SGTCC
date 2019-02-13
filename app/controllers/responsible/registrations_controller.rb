class Responsible::RegistrationsController < Devise::RegistrationsController
  include LDAPAuthentication

  layout 'layouts/professors/application'

  protected

  def after_update_path_for(*)
    edit_responsible_registration_path
  end

  def account_update_params
    params.require(:professor).permit(:name,
                                      :email,
                                      :current_password,
                                      :profile_image,
                                      :profile_image_cache)
  end
end
