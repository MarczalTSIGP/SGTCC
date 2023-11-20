require 'active_support/concern'

module ExaminationBoardFilter
  extend ActiveSupport::Concern

  included do
    def self.by_tcc(data, page, term)
      data.search(term).page(page).with_relationships
    end

    def self.by_tcc_one(page, term, status = nil)
      by_tcc(tcc_one(status), page, term).recent
    end

    def self.by_tcc_two(page, term, status = nil)
      by_tcc(tcc_two(status), page, term).recent
    end
  end
end