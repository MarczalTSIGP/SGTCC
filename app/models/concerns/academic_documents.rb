require 'active_support/concern'

module AcademicDocuments
  extend ActiveSupport::Concern

  included do
    def find_document_by_identifier_and_final_version(identifier, final_version)
      condition = { identifier: identifier, final_version: final_version }
      academic_activities.joins(:activity)
                         .find_by(activities: condition)
    end

    def proposal
      find_document_by_identifier_and_final_version(:proposal, false)
    end

    def project
      find_document_by_identifier_and_final_version(:project, false)
    end

    def monograph
      find_document_by_identifier_and_final_version(:monograph, false)
    end
  end
end
