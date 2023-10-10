module Helpers
  module Button
    def sign_out_button
      I18n.t('sessions.sign_out')
    end

    def orientation_abandon_button
      I18n.t('views.buttons.orientation.abandon')
    end

    def orientation_cancel_button
      I18n.t('views.buttons.orientation.cancel')
    end

    def signature_button
      I18n.t('views.buttons.signature.sign')
    end

    def save_button
      I18n.t('views.buttons.save')
    end

    def authenticate_button
      I18n.t('views.buttons.authenticate')
    end

    def cancel_button
      I18n.t('views.buttons.cancel')
    end

    def sign_button
      I18n.t('views.buttons.sign')
    end

    def ok_button
      'OK'
    end

    def click_on_label(name, options = {})
      within(".#{options[:in]}") do
        find("span[class='custom-control-label']", text: name).click
      end
    end
  end
end
