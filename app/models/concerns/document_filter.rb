require 'active_support/concern'

module DocumentFilter
  extend ActiveSupport::Concern

  included do
    def page_with_relationships(data, page)
      data.page(page).with_relationships
    end

    def documents_pending(page = nil)
      data = documents(false)
      page_with_relationships(data, page)
    end

    def documents_signed(page = nil)
      data = documents(true)
      page_with_relationships(data, page)
    end

    def documents_reviewing(page = nil)
      data = documents(false).where.not(request: nil)
      page_with_relationships(data, page)
    end
  end
end
