class Professors::RegistrationsController < Devise::RegistrationsController
  layout 'layouts/professors/application'

  protected

  def after_update_path_for(*)
    edit_professor_registration_path
  end

  def account_update_params
    params.require(:professor).permit(:email,
                                      :password,
                                      :password_confirmation,
                                      :current_password,
                                      :profile_image,
                                      :profile_image_cache)
  end
end
