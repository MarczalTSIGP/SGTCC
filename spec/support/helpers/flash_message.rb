module Helpers
  module FlashMessage
    def errors_message
      I18n.t('flash.actions.errors')
    end

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

    def no_results_message
      I18n.t('helpers.no_results')
    end

    def message(key)
      I18n.t("flash.actions.#{key}", resource_name: resource_name)
    end

    def orientation_renew_calendar_error_message
      I18n.t('json.messages.orientation.calendar.errors.empty_next_semester')
    end

    def orientation_edit_signed_warning_message
      I18n.t('flash.orientation.edit.signed')
    end

    def orientation_destroy_signed_warning_message
      I18n.t('flash.orientation.destroy.signed')
    end

    def signature_signed_success_message
      I18n.t('json.messages.orientation.signatures.confirm.success')
    end

    def signature_login_alert_message
      I18n.t('json.messages.orientation.signatures.confirm.error')
    end

    def signature_register(name, role, date, time)
      I18n.t('signatures.register', name: name, role: role, date: date, time: time)
    end

    def signature_role(user_gender, user_type)
      I18n.t("signatures.users.roles.#{user_gender}.#{user_type}")
    end
  end
end
