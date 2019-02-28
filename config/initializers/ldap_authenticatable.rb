if ENV['ldap.on'].eql?('true')
  require './lib/ldap/ldap_authentication'
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

          user = Professor.find_by(username: username)
          return success!(user) if user && SGTCC::LDAP.authenticate(username, password, :professors)

          fail(:invalid_login)
        end

        def authenticate_academic
          username = normalize_ra_to_find
          password = params[:academic][:password]

          user = Academic.find_by(ra: username)
          username = normalize_ra_to_authenticate
          return success!(user) if user && SGTCC::LDAP.authenticate(username, password, :academics)

          fail(:invalid_login)
        end

        def normalize_ra_to_find
          ra = params[:academic][:ra]
          return ra unless ra.chr.eql?('a')
          ra[1..-1]
        end

        def normalize_ra_to_authenticate
          ra = params[:academic][:ra]
          return ra if ra.chr.eql?('a')
          "a#{ra}"
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
