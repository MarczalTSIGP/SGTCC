# config valid only for current version of Capistrano
lock "3.15.0"

set :stages, ["production"]

set :application,     'sgtcc'
set :branch,          'production'

set :user,            'deployer'
set :repo_url,        'git@github.com:utfpr-gp-tsi/SGTCC.git'
set :keep_releases,   3

set :puma_threads,    [4, 16] # Min and Max threads per worker

set :nvm_type, :user
set :nvm_node, 'v11.10.0'

# === Cluster mode ===

# How many worker processes to run.
# The default is “0”
set :puma_workers,    1       # Change to match your CPU core count

# Don't change these unless you know what you're doing
set :pty,             true    # is a pair of pseudo-devices, one of which, the slave, emulates a real text terminal device, the other of which, the master, provides the means by which a terminal emulator process controls the slave.
set :use_sudo,        false   # not use sudo to run the comands
set :deploy_via,      :remote_cache # allows you to cache your deployment repo to make deployment much faster.
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa) } # Log in with ssh and private key

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock" # Bind the server to url
set :puma_state,      "#{shared_path}/tmp/pids/puma.state" # Use path as the file to store the server info state.
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid" # process identifier
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
# Preloading your application reduces the startup time of individual Puma worker processes and allows you to manage the external connections of each individual worker using the on_worker_boot calls. In the config above, these calls are used to correctly establish Postgres connections for each worker process.
set :puma_preload_app, true
# Verifies that all workers have checked in to the master process within
# the given timeout. If not the worker process will be restarted. This is
# not a request timeout, it is to protect against a hung or dead process.
# Setting this value will not protect against slow requests.
# Default value is 60 seconds.
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

set :format,        :pretty
set :log_level,     :debug

## Linked Files & Directories (Default None):
set :linked_files, %w{config/secrets.yml config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/production`
        puts "WARNING: HEAD is not the same as origin/production"
        puts "Run `git push` to cap production deploy --dry-runsync changes."
        exit
      end
    end
  end

  desc 'Create base Directories'
  task :setup do
    on roles(:app) do
      execute :mkdir, "-p", shared_path, releases_path
      execute :mkdir, "-p", "#{shared_path}/config"

      ask :db_pwd, 'default', echo: false

      upload! application_contents, "#{shared_path}/config/application.yml"
      upload! secrets_contents, "#{shared_path}/config/secrets.yml"
    end
  end

  desc 'Reload nginx'
  task :reload_ngnix do
    on roles(:app) do
      sudo :service, :nginx, :reload
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
end

############################################
# Helpers methods                          #
############################################
def application_contents
  database = <<-EOF
production:
  db.username: postgres
  db.password: postgres
  mailer.host: sgtcc.tsi.pro.br
  mailer.port: '80'
EOF
  StringIO.new(database)
end

def secrets_contents
  secret = %x[rails secret]
  secrets = <<-EOF
production:
  secret_key_base: #{secret}
EOF
  StringIO.new(secrets)
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
