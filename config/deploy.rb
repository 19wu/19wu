#变量定义到~/.zshrc
#export CAP_PORT=10000
#export CAP_WEB_HOST=188.188.188.188
#export CAP_APP_HOST=$CAP_WEB_HOST
#export CAP_DB_HOST=$CAP_WEB_HOST
#export CAP_USER=deploy
require "rvm/capistrano"                                 # Load RVM's capistrano plugin.
require "bundler/capistrano" # 集成bundler和rvm
require "delayed/recipes"
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :rails_env, "production"                             # added for delayed job
set :rvm_ruby_string, 'ruby-2.0.0'                       # Or whatever env you want it to run in.
set :rvm_type, :user                                     # Copy the exact line. I really mean :user here
#set :bundle_flags,    "--deployment --verbose"          # Just for debug
set :bundle_without,  [:development, :test, :sqlite3, :mysql2]

set :application, "19wu"
set :port, ENV['CAP_PORT']
role :web, ENV['CAP_WEB_HOST']                          # Your HTTP server, Apache/etc
role :app, ENV['CAP_APP_HOST'], jobs: true              # This may be the same as your `Web` server
role :db,  ENV['CAP_DB_HOST'], primary: true            # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :delayed_job_command, 'bin/delayed_job'

set :repository,  "git://github.com/19wu/#{application}.git"
set :scm, :git
set :deploy_to, "/u/apps/#{application}" # default
set :deploy_via, :remote_cache # 不要每次都获取全新的repository
set :branch, "master"
set :user, ENV['CAP_USER']
set :use_sudo, false

set :pids_path, "#{shared_path}/pids"

depend :remote, :gem, "bundler", ">=1.0.21" # 可以通过 cap deploy:check 检查依赖情况

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do

  task :start do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  task :stop do
    run "kill -s QUIT `cat #{pids_path}/unicorn.#{application}.pid`"
  end

  task :restart, roles: :app, except: { no_release: true } do
    run "kill -s USR2 `cat #{pids_path}/unicorn.#{application}.pid`"
  end

  # scp -P $CAP_PORT config/{database,settings}.yml $CAP_USER@$CAP_APP_HOST:/u/apps/19wu/shared/config/
  desc "Symlink shared resources on each release" # 配置文件
  task :symlink_shared, roles: :app do
    %w(database.yml settings.yml).each do |secure_file|
      run "ln -nfs #{shared_path}/config/#{secure_file} #{release_path}/config/#{secure_file}"
    end
  end

  desc "Populates the Production Database"
  task :seed do
    run "cd #{release_path} ; bundle exec rake db:seed"
  end

  desc "create config shared path"
  task :add_shared_dir, roles: :app do
    run "mkdir -p #{shared_path}/config"
    %w(database.yml settings.yml).each do |file|
      run_locally "scp -P $CAP_PORT config/#{file} $CAP_USER@$CAP_APP_HOST:/u/apps/19wu/shared/config/"
    end
  end

end

namespace :carrierwave do
  task :symlink, roles: :app do
    run "mkdir -p #{shared_path}/uploads"
    run "ln -nfs #{shared_path}/uploads/ #{release_path}/public/uploads"
  end
end


before 'deploy:migrate'          , 'deploy:symlink_shared'
before 'deploy:assets:precompile', 'deploy:symlink_shared'
after 'deploy:setup'             , 'deploy:add_shared_dir'
after 'deploy:migrate'           , 'deploy:seed'

after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, or:

after "deploy:finalize_update", "carrierwave:symlink"
