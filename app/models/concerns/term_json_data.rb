require 'active_support/concern'

module TermJsonData
  extend ActiveSupport::Concern

  included do
    def term_json_data
      { orientation: orientation_data, advisor: advisor_data, title: document_type.name.upcase,
        academic: academic_data, institution: institution_data, document: { id: id },
        professorSupervisors: orientation.professor_supervisors_to_document,
        externalMemberSupervisors: orientation.external_member_supervisors_to_document,
        examination_board: examination_board_data }
    end

    private

    def orientation_data
      { id: orientation.id, title: orientation.title,
        created_at: I18n.l(orientation.created_at, format: :document) }
    end

    def advisor_data
      advisor = orientation.advisor
      { id: advisor.id, name: "#{advisor.scholarity.abbr} #{advisor.name}",
        label: I18n.t("signatures.advisor.labels.#{advisor.gender}") }
    end

    def academic_data
      academic = orientation.academic
      { id: academic.id, name: academic.name, ra: academic.ra }
    end

    def institution_data
      institution = orientation.institution
      { id: institution&.id, trade_name: institution&.trade_name,
        responsible: institution&.external_member&.name }
    end

    def examination_board_data
      return if examination_board.blank?
      { id: examination_board[:id], evaluators: examination_board[:evaluators],
        date: examination_board[:date], time: examination_board[:time] }
    end
  end
end
