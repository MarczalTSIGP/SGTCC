# Reunião só pode ser alterada ou excluída enquanto o acadêmico não a visualizou.
# O predicado de estado (`Meeting#can_update?`) continua no model.
class MeetingPolicy < ApplicationPolicy
  def update?
    record.can_update?
  end

  alias destroy? update?
end
