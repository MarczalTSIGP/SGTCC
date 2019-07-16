require 'active_support/concern'

module TermJsonData
  extend ActiveSupport::Concern

  included do
    def term_json_data
      { orientation: orientation_data, advisor: advisor_data, title: document_type.name.upcase,
        academic: academic_data, institution: institution_data,
        professorSupervisors: first_orientation.professor_supervisors_to_document,
        externalMemberSupervisors: first_orientation.external_member_supervisors_to_document }
    end

    private

    def advisor_data
      advisor = first_orientation.advisor
      { id: advisor.id, name: "#{advisor.scholarity.abbr} #{advisor.name}",
        label: I18n.t("signatures.advisor.labels.#{advisor.gender}") }
    end

    def academic_data
      academic = first_orientation.academic
      { id: academic.id, name: academic.name, ra: academic.ra }
    end

    def institution_data
      institution = first_orientation.institution
      { id: institution&.id, trade_name: institution&.trade_name,
        responsible: institution&.external_member&.name }
    end
  end
end
