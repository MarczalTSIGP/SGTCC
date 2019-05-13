module Helpers
  module Link
    def click_on_destroy_link(url)
      destroy_link = "a[href='#{url}'][data-method='delete']"
      find(destroy_link).click
    end

    def link(link)
      "a[href='#{link}']"
    end
  end
end
