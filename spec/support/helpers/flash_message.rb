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

    def document_not_found_message
      I18n.t('json.messages.documents.errors.not_found')
    end

    def document_authenticated_message
      I18n.t('json.messages.documents.success.authenticated')
    end

    def confirm_password_error_message
      I18n.t('devise.registrations.edit.we_need_your_current_password_to_confirm_your_changes')
    end

    def image_error_message
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

    def invalid_code_message
      I18n.t('json.messages.invalid_code')
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

    def request_resource_name
      I18n.t('flash.request.index')
    end

    def message(key)
      I18n.t("flash.actions.#{key}", resource_name:)
    end

    def orientation_edit_signed_warning_message
      I18n.t('flash.orientation.edit.signed')
    end

    def orientation_destroy_signed_warning_message
      I18n.t('flash.orientation.destroy.signed')
    end

    def meeting_edit_warning_message
      I18n.t('flash.orientation.meeting.errors.edit')
    end

    def meeting_destroy_warning_message
      I18n.t('flash.orientation.meeting.errors.destroy')
    end

    def signature_signed_success_message
      I18n.t('json.messages.orientation.signatures.confirm.success')
    end

    def signature_login_alert_message
      I18n.t('json.messages.orientation.signatures.confirm.error')
    end

    def signature_register(name, role, date, time)
      I18n.t('signatures.register', name:, role:, date:, time:)
    end

    def signature_role(user_gender, user_type)
      I18n.t("signatures.users.roles.#{user_gender}.#{user_type}")
    end

    def signature_code_message(signature_code)
      url = "#{current_host}:#{URI.parse(current_url).port}#{confirm_document_code_path}"
      I18n.t('signatures.code', url:, code: signature_code.code)
    end

    def document_academic_not_allowed_message
      I18n.t('flash.documents.academics.requests.not_allowed')
    end

    def document_professor_not_allowed_message
      I18n.t('flash.documents.professors.requests.not_allowed')
    end

    def document_errors_update_message
      I18n.t('json.messages.documents.errors.update')
    end
  end
end
