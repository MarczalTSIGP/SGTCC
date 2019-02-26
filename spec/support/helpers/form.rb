module Helpers
  module Form
    def submit_form(submit = '//input[type=submit]')
      find(submit).click
    end

    def expect_alert_success(name, message)
      expect(page).to have_selector('div.alert.alert-success',
                                    text: I18n.t(message, resource_name: name))
    end
  end
end
