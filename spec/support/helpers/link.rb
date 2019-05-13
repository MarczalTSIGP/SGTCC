module Helpers
  module Link
    def click_on_destroy_link(url, options = {})
      destroy_link = "a[href='#{url}'][data-method='delete']"
      find(destroy_link).click
    end
  end
end
