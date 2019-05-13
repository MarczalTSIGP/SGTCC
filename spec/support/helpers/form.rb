module Helpers
  module Form
    def submit_form(submit = '//input[type=submit]')
      find(submit).click
    end

    def selectize(name, options = {})
      find("\##{options[:from]}-selectized").click
      find('div.selectize-dropdown-content .option', text: name).click
    end

    def message_blank_error
      I18n.t('errors.messages.blank')
    end

    def message_required_error
      I18n.t('errors.messages.required')
    end

    def flash_message(method, resource_name)
      I18n.t("flash.actions.#{method}", resource_name: resource_name)
    end

    def accept_alert
      alert = page.driver.browser.switch_to.alert
      alert.accept
    end

    def radio(name, options = {})
      within(".#{options[:in]}") do
        find("span[class='custom-control-label']", text: name).click
      end
    end
  end
end
