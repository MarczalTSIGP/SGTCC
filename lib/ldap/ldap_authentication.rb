require 'net/ldap'

module SGTCC
  class LDAP
    def self.authenticate(user, pwd, base)
      ldap = Net::LDAP.new

      ldap.host = ENV['ldap.host']
      ldap.port = ENV['ldap.port']

      base = ENV["ldap.base.#{base}"]
      ldap.authenticate "uid=#{user},#{base}", pwd

      return true if ldap.bind

      false
    end
  end
end
