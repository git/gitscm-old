set :application, "gitscm"
set :repository,  "git://github.com/schacon/gitscm.git"

default_run_options[:pty] = true

set :scm, "git"
set :runner, 'app'
set :user, 'app'

set :use_sudo, true
set :branch, 'master'
set :user, 'app'

set :deploy_via, :remote_cache

set :domain, 'git-scm.com'
role :app, domain
role :web, domain
role :db,  domain, :primary => true

task :update_config,  :roles => [:app] do
  run "cp -Rf #{shared_path}/config/*       #{release_path}/config/"
end
after  'deploy:update_code',     :update_config

namespace :passenger do
  desc 'Restart Application'
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, 'passenger:restart'
