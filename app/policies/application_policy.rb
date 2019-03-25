class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def professor_responsible?
    @user.role?(I18n.t('enums.roles.responsible'))
  end
end
