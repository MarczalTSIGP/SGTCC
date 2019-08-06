require 'active_support/concern'

module SignatureFilter
  extend ActiveSupport::Concern

  included do
    def page_with_relationships(data, page)
      data.page(page).with_relationships
    end

    def signatures_pending(page = nil)
      data = signatures.where(status: false)
      page_with_relationships(data, page)
    end

    def signatures_signed(page = nil, term = nil)
      data = signatures.where(status: true).search(term)
      page_with_relationships(data, page)
    end

    def signatures_for_review(page = nil)
      data = signatures.joins(:document)
                       .where.not(documents: { request: nil })
      page_with_relationships(data, page)
    end
  end
end
