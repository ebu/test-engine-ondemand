set :deploy_host, "ec2-54-72-20-137.eu-west-1.compute.amazonaws.com"
set :deploy_to, "/var/www/#{application}/rails"

set :branch, "master"

set :rails_env, "production"

role :web, deploy_host
role :app, deploy_host
role :db,  deploy_host

