class ExaminationBoardNote < ApplicationRecord
  belongs_to :examination_board
  belongs_to :professor, optional: true
  belongs_to :external_member, optional: true

  mount_uploader :appointment_file, FileUploader

  validates :note,
            presence: true,
            numericality: { only_integer: true,
                            greater_than: 0,
                            less_than_or_equal_to: 100 }

  validates :appointment_file,
            presence: true

  after_save do
    if examination_board.all_evaluated?
      status = examination_board.final_note >= 60 ? :approved : :reproved
      examination_board.update(situation: status,
                               final_note: examination_board.final_note)
      examination_board.create_defense_minutes
    end
  end
end
