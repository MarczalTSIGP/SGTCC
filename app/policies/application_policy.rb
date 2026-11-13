# Base dos Policy Objects: decisões de autorização de um sujeito (`user`) sobre um
# registro (`record`). As policies só decidem; o controller continua responsável pela
# resposta HTTP (redirect e flash) quando a decisão é negativa.
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end
end
