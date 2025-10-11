module Helpers
  module Link
    def click_on_destroy_link(path)
      find("a[href='#{path}'][data-method='delete'], a[href='#{path}'][data-turbo-method='delete']").click
    end

    def link(link)
      "a[href='#{link}']"
    end
  end
end
