require 'active_support/concern'

module AcademicDocumentsInfo
  extend ActiveSupport::Concern

  included do
    def document_tcc_one
      final_project || project || final_proposal || proposal
    end

    def document_tcc_two
      final_monograph || monograph
    end

    def document_summary
      document = calendar_tcc_one? ? document_tcc_one : document_tcc_two
      document&.summary
    end

    def document_title
      document = calendar_tcc_one? ? document_tcc_one : document_tcc_two
      document&.title || title
    end
  end
end
