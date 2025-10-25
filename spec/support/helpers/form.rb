module Helpers
  module Form
    def submit_form(submit = '//input[type=submit]')
      expect(page).to have_no_css('div.ss-content', visible: :visible, wait: 1)

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
      select_element = find("select##{options[:from]}", visible: :all)
      parent_element = select_element.find(:xpath, './..')

      open_slim_select_dropdown(parent_element)
      select_option_from_dropdown(name)
      close_dropdown_if_needed(select_element, parent_element)
    end

    def open_slim_select_dropdown(parent_element)
      within(parent_element) do
        button = find("[data-id^='ss-']", wait: 5)
        button.click
      end
    end

    def select_option_from_dropdown(name)
      dropdowns = all('div.ss-content', visible: :visible, wait: 5)
      dropdown = dropdowns.last
      option = dropdown.find("div[role='option']", text: name, exact_text: true, wait: 5)
      option.click
    end

    def close_dropdown_if_needed(select_element, parent_element)
      multiple = select_element[:multiple].present?

      if multiple
        within(parent_element) do
          button = find("[data-id^='ss-']", wait: 5)
          button.click
        end
      else
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
