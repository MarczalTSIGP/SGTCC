# Nota e apontamentos de uma banca só podem mudar enquanto a ata de defesa não existe.
# `record` é a banca, porque na criação ainda não há nota.
class ExaminationBoardNotePolicy < ApplicationPolicy
  def edit?
    record.defense_minutes.blank?
  end
end
