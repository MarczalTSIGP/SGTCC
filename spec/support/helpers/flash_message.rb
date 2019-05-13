module Helpers
  module FlashMessage
    def blank_error_message
      I18n.t('errors.messages.blank')
    end

    def required_error_message
      I18n.t('errors.messages.required')
    end

    def invalid_error_message
      I18n.t('errors.messages.invalid')
    end

    def default_error_message
      I18n.t('simple_form.error_notification.default_message')
    end

    def confirm_password_error_message
      I18n.t('devise.registrations.edit.we_need_your_current_password_to_confirm_your_changes')
    end

    def profile_image_error_message
      I18n.t('errors.messages.extension_whitelist_error', extension: '"pdf"',
                                                          allowed_types: 'jpg, jpeg, gif, png')
    end

    def signed_in_message
      I18n.t('devise.sessions.signed_in')
    end

    def already_signed_out_message
      I18n.t('devise.sessions.already_signed_out')
    end

    def invalid_sign_in_message
      I18n.t('devise.failure.invalid', authentication_keys: resource_name)
    end

    def registrations_updated_message
      I18n.t('devise.registrations.updated')
    end

    def unauthenticated_message
      I18n.t('devise.failure.unauthenticated')
    end

    def not_authorized_message
      I18n.t('flash.not_authorized')
    end

    def flash_message(method, resource_name)
      I18n.t("flash.actions.#{method}", resource_name: resource_name)
    end
  end
end
