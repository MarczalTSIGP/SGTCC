module LDAPAuthentication
  extend ActiveSupport::Concern

  protected

  def update_resource(resource, params)
    user = current_academic || current_professor

    if SGTCC::LDAP.enable? &&
       SGTCC::LDAP.authenticate(user, params[:current_password])

      params.delete(:current_password)
      return resource.update_without_password(params)
    end

    super
  end
end
