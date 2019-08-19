require 'active_support/concern'

module DocumentFilter
  extend ActiveSupport::Concern

  included do
    def page_with_relationships(data, page)
      data.page(page).with_relationships
    end

    def documents_pending(page = nil)
      data = documents(false).where(request: nil)
      page_with_relationships(data, page)
    end

    def documents_signed(page = nil)
      data = documents(true)
      page_with_relationships(data, page)
    end

    def documents_reviewing(page = nil)
      data = documents.with_relationships.where.not(request: nil)
      data = data.select do |document|
        document.send("#{document.document_type.identifier}_for_review?")
      end
      Kaminari.paginate_array(data).page(page)
    end

    def documents_request(page = nil)
      data = documents.where(document_types: { identifier: :tdo })
                      .where.not(request: nil)
      page_with_relationships(data, page)
    end
  end
end
