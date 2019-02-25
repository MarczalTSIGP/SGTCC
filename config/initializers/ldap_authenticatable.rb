if ENV['ldap.on'].eql?('true')
  require './lib/ldap/ldap_authentication'
  require 'devise/strategies/authenticatable'

  module Devise
    module Strategies
      class LdapAuthenticatable < Authenticatable
        def authenticate!
          return unless params[:professor]

          user = Professor.find_by(username: username)

          return success!(user) if user && SGTCC::LDAP.authenticate(username, password)

          fail(:invalid_login)
        end

        def username
          params[:professor][:username]
        end

        def password
          params[:professor][:password]
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
    end
  end
end
