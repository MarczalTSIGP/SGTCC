class ExternalMembers::RegistrationsController < Devise::RegistrationsController
  layout 'layouts/external_members/application'

  protected

  def after_update_path_for(*)
    edit_external_members_registration_path
  end

  def account_update_params
    params.require(:external_member)
          .permit(:name, :email, :personal_page,
                  :password, :password_confirmation,
                  :current_password,
                  :profile_image,
                  :profile_image_cache)
  end
end
