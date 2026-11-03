RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end

    DatabaseCleaner[:active_record].clean_with(:truncation)
    DatabaseCleaner[:active_record, db: :queue].clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner[:active_record, db: :queue].strategy = :truncation
  end

  # Todo spec de feature deste projeto roda no Chrome remoto: `spec/support/capybara.rb`
  # define `Capybara.default_driver = :chrome`, então o app sob teste NÃO compartilha a
  # conexão de banco com o spec e a estratégia precisa ser truncation.
  #
  # A verificação `Capybara.current_driver == :rack_test`, que existia aqui e serviria para
  # manter transaction nos specs que compartilham conexão, nunca era verdadeira — era ramo
  # morto com aparência de proteção ativa. Se algum dia um driver :rack_test for adotado
  # para specs de feature mais rápidos, a condição precisa voltar.
  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner[:active_record, db: :queue].strategy = :truncation
  end

  config.before do
    DatabaseCleaner.start
    DatabaseCleaner[:active_record, db: :queue].start
  end

  config.append_after do
    DatabaseCleaner.clean
    DatabaseCleaner[:active_record, db: :queue].clean
  end
end
