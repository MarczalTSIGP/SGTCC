module Helpers
  module Form
    def submit_form(submit = '//input[type=submit]')
      find(submit).click
    end

    def selectize(name, options = {})
      find("\##{options[:from]}-selectized").click
      find('div.selectize-dropdown-content .option', text: name).click
    end

    def accept_alert
      alert = page.driver.browser.switch_to.alert
      alert.accept
    end
  end
end
