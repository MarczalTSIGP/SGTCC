require './lib/ldap/ldap_authentication'

if SGTCC::LDAP.enable?
  require 'devise/strategies/authenticatable'

  module Devise
    module Strategies
      class LdapAuthenticatable < Authenticatable
        def authenticate!
          return authenticate_professor if params[:professor]
          authenticate_academic
        end

        def authenticate_professor
          username = params[:professor][:username]
          password = params[:professor][:password]

          professor = Professor.find_by(username: username)
          return success!(professor) if SGTCC::LDAP.authenticate(professor, password)

          fail(:invalid_login)
        end

        def authenticate_academic
          ra = params[:academic][:ra]
          password = params[:academic][:password]

          academic = Academic.find_through_ra(ra)
          return success!(academic) if SGTCC::LDAP.authenticate(academic, password)

          fail(:invalid_login)
        end
      end
    end
  end

  Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)

  Devise.setup do |config|
    config.warden do |manager|
      manager.intercept_401 = false

      manager.default_strategies(scope: :professor).delete :database_authenticatable
      manager.default_strategies(scope: :professor).unshift :ldap_authenticatable

      manager.default_strategies(scope: :academic).delete :database_authenticatable
      manager.default_strategies(scope: :academic).unshift :ldap_authenticatable
    end
  end
end
