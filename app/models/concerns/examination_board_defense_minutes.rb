require 'active_support/concern'

module ExaminationBoardDefenseMinutes
  extend ActiveSupport::Concern

  included do
    def create_defense_minutes
      data_params = { orientation_id: orientation.id, examination_board: examination_board_data }
      DocumentType.find_by(identifier: minutes_type).documents.create!(data_params)
    end

    def create_non_attendance_defense_minutes
      update(situation: :not_appear)
      create_defense_minutes
    end

    def available_defense_minutes?
      (Time.current <= document_available_until)
    end

    def defense_minutes
      document_type = DocumentType.find_by(identifier: minutes_type)
      return if document_type.blank?

      condition = "content -> 'examination_board' ->> 'id' = ?"
      orientation.documents.where(document_type_id: document_type.id).find_by(condition, id.to_s)
    end
  end
end
