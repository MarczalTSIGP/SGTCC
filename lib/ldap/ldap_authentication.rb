require 'net/ldap'
require 'mechanize'

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
      return moodle_authenticate(user, pwd) if ENV['ldap.by'].eql?('moodle')

      ldap = Net::LDAP.new

      ldap.host = ENV.fetch('ldap.host', nil)
      ldap.port = ENV.fetch('ldap.port', nil)

      base = ENV.fetch("ldap.base.#{base}", nil)
      ldap.authenticate "uid=#{user},#{base}", pwd

      return true if ldap.bind

      false
    end

    def self.moodle_authenticate(user, pwd)
      url = 'https://moodle.utfpr.edu.br/login/index.php'

      mechanize = Mechanize.new
      page = mechanize.get url

      form = page.forms[0]
      form.field_with(id: 'username').value = user
      form.field_with(id: 'password').value = pwd
      resp = form.submit

      resp.title.eql?('Painel | Moodle UTFPR')
    end

    private_class_method :base_authenticate
  end
end
