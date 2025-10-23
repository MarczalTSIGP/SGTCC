module Helpers
  module Form
    def submit_form(submit = '//input[type=submit]')
      expect(page).to have_no_css('div.ss-content', visible: true, wait: 1)
      
      submit_button = find(submit)
      submit_button.scroll_to(submit_button, align: :center)
      sleep 0.2
      submit_button.click
    end

    def selectize(name, options = {})
      find("##{options[:from]}-selectized").click
      find('div.selectize-dropdown-content .option', text: name, exact_text: true).click
    end

    def slim_select(name, options = {})
      within("div.#{options[:from]}") do
        find("[data-id^='ss-']").click
      end
      
      sleep 0.3
      dropdown = find_all('div.ss-content', visible: true).first
      option = dropdown.find("div[role='option']", text: name)
      option.click
      
      begin
        expect(page).to have_no_css('div.ss-content', visible: true, wait: 2)
      rescue RSpec::Expectations::ExpectationNotMetError
        page.execute_script("document.querySelectorAll('.ss-content').forEach(el => el.remove())")
      end
    end

    def fill_in_simple_mde(markdown)
      script = "var CodeMirror = document.querySelector('.CodeMirror').CodeMirror;"
      script += "CodeMirror.getDoc().setValue('#{markdown}');"
      page.execute_script(script)
    end
  end
end
