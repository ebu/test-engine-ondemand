set :deploy_host, "ebu-ondemand.madebyhiro.com"
set :deploy_to, "/var/www/#{application}/rails"

set :branch, "master"

set :rails_env, "production"

role :web, deploy_host
role :app, deploy_host
role :db,  deploy_host

