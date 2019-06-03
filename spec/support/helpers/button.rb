module Helpers
  module Button
    def sign_out_button
      I18n.t('sessions.sign_out')
    end

    def orientation_renew_button
      I18n.t('views.buttons.orientation.renew')
    end

    def save_button
      I18n.t('views.buttons.save')
    end

    def cancel_button
      I18n.t('views.buttons.cancel')
    end

    def click_on_label(name, options = {})
      within(".#{options[:in]}") do
        find("span[class='custom-control-label']", text: name).click
      end
    end
  end
end
