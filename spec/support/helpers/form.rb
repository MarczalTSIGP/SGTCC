module Helpers
  module Form
    def submit_form(submit = '//input[type=submit]')
      find(submit).click
    end
  end
end
