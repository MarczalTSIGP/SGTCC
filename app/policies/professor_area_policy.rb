# Acesso às áreas restritas da aplicação pelo papel do professor.
class ProfessorAreaPolicy < ApplicationPolicy
  def initialize(professor)
    super(professor, nil)
  end

  def responsible_area?
    user.role?('responsible')
  end

  def tcc_one_area?
    user.role?('tcc_one')
  end
end
