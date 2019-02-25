require 'simplecov'
require 'simplecov-console'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter
                      .new([
                             SimpleCov::Formatter::HTMLFormatter,
                             SimpleCov::Formatter::Console
                           ])

SimpleCov.start 'rails' do
  minimum_coverage 90
  refuse_coverage_drop

  add_filter %r{^/(?!app|lib)/}
  add_filter %r{^/app/channels/}

  add_filter 'app/channels/application_cable'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/models/application_record.rb'
  add_filter 'lib/ldap/ldap_authentication.rb'
  add_filter 'app/controllers/concerns/ldap_authentication.rb'
end
