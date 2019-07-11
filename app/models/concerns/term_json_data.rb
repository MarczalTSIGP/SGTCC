require 'active_support/concern'

module TermJsonData
  extend ActiveSupport::Concern

  included do
    def term_json_data
      { orientation: orientation_data, advisor: advisor_data,
        title: document.document_type.name.upcase,
        academic: orientation.academic, institution: institution_data,
        professorSupervisors: orientation.professor_supervisors_to_document,
        externalMemberSupervisors: orientation.external_member_supervisors_to_document }
    end

    private

    def orientation_data
      { id: orientation.id, title: orientation.title,
        date: I18n.l(orientation.created_at, format: :document) }
    end

    def advisor_data
      advisor = orientation.advisor
      { name: "#{advisor.scholarity.abbr} #{advisor.name}",
        label: I18n.t("signatures.advisor.labels.#{advisor.gender}") }
    end

    def institution_data
      institution = orientation.institution
      { trade_name: institution&.trade_name, responsible: institution&.external_member&.name }
    end
  end
end
