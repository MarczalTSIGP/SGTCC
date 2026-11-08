# Pedidos (TEP, TSO, TDO) só mudam enquanto o solicitante não os assinou.
class RequestPolicy < ApplicationPolicy
  def change?
    !signed_by_requester?
  end

  private

  def signed_by_requester?
    case user
    when Academic then record.academic_signed?(user)
    when Professor then record.professor_signed?(user)
    else raise ArgumentError, "Unsupported requester: #{user.class.name}"
    end
  end
end
