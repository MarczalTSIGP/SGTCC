module Helpers
  module Button
    def sign_out_button
      I18n.t('sessions.sign_out')
    end

    def click_on_label(name, options = {})
      within(".#{options[:in]}") do
        find("span[class='custom-control-label']", text: name).click
      end
    end
  end
end
