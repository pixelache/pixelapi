# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "pixelapi"
set :repo_url, "git://github.com/pixelache/pixelapi.git"
set :rvm_ruby_version, '2.7.3'
set :keep_releases, 3
set :linked_files, %w{config/database.yml config/puma.rb }
set :linked_dirs, %w{public/system tmp config/credentials public/uploads public/images public/assets log}

set :assets_roles, [:web, :app]       
 
set :puma_threads,    [3, 6]
set :puma_workers, 3
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false


set :rails_env, 'production'
set :migrate_env, 'production'
set :deploy_to, '/var/www/pixelapi'
set :ssh_options, compression: false, keepalive: true

namespace :deploy do

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end
  
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      # before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end
  
  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     invoke 'puma:start'
  #   end
  # end
  
  before :starting,     :check_revision
  after  :finishing,    :cleanup
  after  :finishing,    :restart

end


