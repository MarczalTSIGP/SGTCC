set :stage, :production

server '200.134.18.134', roles: %w(app web db), primary: true, user: 'deployer'
set :rails_env, "production"
