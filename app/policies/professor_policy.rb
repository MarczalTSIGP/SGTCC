class ProfessorPolicy < ApplicationPolicy
  def index?
    professor_responsible?
  end
end
