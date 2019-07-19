require 'active_support/concern'

module SignatureFilter
  extend ActiveSupport::Concern

  included do
    def signatures_by_status(status, page)
      signatures.where(status: status).page(page).with_relationships
    end

    def signatures_pending(page = nil)
      signatures_by_status(false, page)
    end

    def signatures_signed(page = nil)
      signatures_by_status(true, page)
    end

    def signatures_for_review(page = nil)
      signatures_by_status(false, page)
    end
  end
end
