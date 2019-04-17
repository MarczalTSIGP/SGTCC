class Professors::RegistrationsController < Devise::RegistrationsController
  include LDAPAuthentication

  layout 'layouts/professors/application'

  protected

  def after_update_path_for(*)
    edit_professor_registration_path
  end

  def account_update_params
    params.require(:professor).permit(:name, :email, :lattes,
                                      :professor_title_id,
                                      :professor_type_id,
                                      :gender, :working_area,
                                      :scholarity_id,
                                      :available_advisor,
                                      :current_password,
                                      :profile_image,
                                      :profile_image_cache)
  end
end
