set :application, "facilitationpatterns"
set :user, "stellsmi"
set :home, "/users/home/stellsmi"
set :deploy_to, "#{home}/apps/#{application}"

set :scm, :git
set :repository, "git://github.com/jeremylightsmith/#{application}.git "
set :branch, "master"
set :deploy_via, :remote_cache

role :app, "onemanswalk.com"
role :web, "onemanswalk.com"
role :db,  "onemanswalk.com", :primary => true

desc "pull code from github"
task :pull do
  run "cd #{deploy_to}/../actionsite && git pull"
  run "cd #{deploy_to} && git pull && rake generate"
end 
