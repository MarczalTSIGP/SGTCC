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

    user = if resource_name == :academic
             "a#{current_academic.ra}"
           else
             current_professor.username
           end

    base = resource_name.to_s.pluralize
    return false unless SGTCC::LDAP.authenticate(user, pwd, base)
    true
  end
end
