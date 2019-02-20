set :stage, :production

server '172.20.11.14', roles: %w(app web db), primary: true, user: 'deployer'
set :rails_env, "production"
