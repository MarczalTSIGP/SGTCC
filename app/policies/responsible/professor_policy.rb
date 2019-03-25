class Responsible::ProfessorPolicy < ApplicationPolicy
  def index?
    professor_responsible?
  end

  def show?
    professor_responsible?
  end

  def create?
    professor_responsible?
  end

  def new?
    create?
  end

  def update?
    professor_responsible?
  end

  def edit?
    update?
  end

  def destroy?
    professor_responsible?
  end
end
