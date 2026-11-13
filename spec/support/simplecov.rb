require 'simplecov'
require 'simplecov-console'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter
                      .new([
                             SimpleCov::Formatter::HTMLFormatter,
                             SimpleCov::Formatter::Console
                           ])

# O gate de cobertura só faz sentido quando a suíte inteira roda: numa execução
# parcial (`rspec spec/models/...`) a cobertura medida é a daquele recorte, e o
# limiar reprovaria o comando mesmo com todos os exemplos verdes.
FULL_SUITE_RUN = ARGV.none? { |arg| arg.start_with?('spec/', './spec/') }

SimpleCov.start 'rails' do
  # Cobertura medida na REF-13D: 96.17%. O limiar de 90% da configuração original é
  # seguro e foi mantido. `refuse_coverage_drop` segue desligado de propósito: ele
  # reprova a suíte a qualquer oscilação para baixo entre execuções, o que atrapalharia
  # a medição comparativa da REF-14.
  minimum_coverage 90 if FULL_SUITE_RUN

  skip %r{^/(?!app|lib)/}
  skip %r{^/app/channels/}

  skip 'app/channels/application_cable'
  skip 'app/jobs/application_job.rb'
  skip 'app/mailers/application_mailer.rb'
  skip 'app/models/application_record.rb'
  skip 'lib/ldap/ldap_authentication.rb'
  skip 'app/controllers/concerns/ldap_authentication.rb'
  skip 'app/controllers/concerns/document_signature.rb'
  skip 'lib/tasks/db/populate'
end
