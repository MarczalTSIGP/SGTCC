class ExaminationBoardPolicy < ApplicationPolicy
  # Bancas de monografia (TCC II) não são alteradas pela área do professor de TCC I.
  def change_as_tcc_one_professor?
    !record.monograph?
  end
end
