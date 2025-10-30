class ExternalMembers::RegistrationsController < Devise::RegistrationsController
  layout 'layouts/external_members/application'

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_to do |format|
        format.html do
          set_flash_message_for_update(resource, prev_unconfirmed_email)
          redirect_to after_update_path_for(resource)
        end
        format.json { render json: { success: true, message: t('devise.registrations.updated') } }
      end
    else
      clean_up_passwords resource
      set_minimum_password_length

      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: {
            success: false,
            errors: resource.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    end
  end

  protected

  def after_update_path_for(*)
    edit_external_member_registration_path
  end

  def account_update_params
    params.require(:external_member)
          .permit(:name, :email, :personal_page,
                  :password, :password_confirmation,
                  :gender, :scholarity_id,
                  :is_active, :current_password,
                  :profile_image, :profile_image_cache)
  end
end
