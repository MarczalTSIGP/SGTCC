module Helpers
  module Form
    def submit_form(submit = '//input[type=submit]')
      find(submit).click
    end

    def selectize(name, options = {})
      find("\##{options[:from]}-selectized").click
      find('div.selectize-dropdown-content .option', text: name, exact_text: true).click
    end

    # def accept_alert
    #   page.driver.browser.accept_alert
    # end

    def fill_in_simple_mde(markdown)
      script = "var CodeMirror = document.querySelector('.CodeMirror').CodeMirror;"
      script += "CodeMirror.getDoc().setValue('#{markdown}');"
      page.execute_script(script)
    end
  end
end
