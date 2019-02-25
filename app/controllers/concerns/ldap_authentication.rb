module LDAPAuthentication
  extend ActiveSupport::Concern

  protected

  def update_resource(resource, params)
    if ENV['ldap.on'].eql?('true') && authenticate(params[:current_password])
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      super
    end
  end

  private

  def authenticate(pwd)
    require './lib/ldap/ldap_authentication'

    user = send(:"current_#{resource_name}").username

    return false unless SGTCC::LDAP.authenticate(user, pwd)
    true
  end
end
