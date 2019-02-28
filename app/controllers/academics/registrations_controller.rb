class Academics::RegistrationsController < Devise::RegistrationsController
  layout 'layouts/academics/application'

  protected

  def after_update_path_for(*)
    edit_academics_registration_path
  end

  def account_update_params
    params.require(:academic).permit(:name,
                                     :email,
                                     :current_password,
                                     :profile_image,
                                     :profile_image_cache)
  end
end
