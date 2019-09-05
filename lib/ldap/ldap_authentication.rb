require 'net/ldap'

module SGTCC
  class LDAP
    def self.enable?
      ENV['ldap.on'].eql?('true')
    end

    def self.authenticate(user, password)
      case user
      when Academic
        base_authenticate("a#{user.ra}", password, :academics)
      when Professor
        base_authenticate(user.username, password, :professors)
      else
        false
      end
    end

    def self.base_authenticate(user, pwd, base)
      ldap = Net::LDAP.new

      ldap.host = ENV['ldap.host']
      ldap.port = ENV['ldap.port']

      base = ENV["ldap.base.#{base}"]
      ldap.authenticate "uid=#{user},#{base}", pwd

      return true if ldap.bind

      false
    end

    private_class_method :base_authenticate
  end
end
