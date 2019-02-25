require 'net/ldap'

module SGTCC
  class LDAP
    def self.authenticate(user, pwd)
      ldap = Net::LDAP.new

      ldap.host = ENV['ldap.host']
      ldap.port = ENV['ldap.port']

      base = 'ou=professores,ou=servidores,ou=usuarios,ou=colaboradores,ou=todos,'
      base += 'dc=utfpr,dc=edu,dc=br'
      ldap.authenticate "uid=#{user},#{base}", pwd

      return true if ldap.bind

      false
    end
  end
end
