require 'capistrano/ext/multistage'

set :application, "ebu-ondemand"
set :stages, %w(production)
set :default_stage, "production"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :scm, :git
set :repository,  "https://github.com/madebyhiro/ebu-ondemand.git"

set :deploy_via, :copy
set :copy_strategy, :export
set :use_sudo, false

set :default_environment,   {
  'PATH'      => "/usr/local/rvm/gems/ruby-2.0.0-p451/bin:/usr/local/rvm/gems/ruby-2.0.0-p451@global/bin:/usr/local/rvm/rubies/ruby-2.0.0-p451/bin:$PATH",
  'GEM_PATH'  => "/usr/local/rvm/gems/ruby-2.0.0-p451:/usr/local/rvm/gems/ruby-2.0.0-p451@global",
  'GEM_HOME'  => "/usr/local/rvm/gems/ruby-2.0.0-p451",
  'LC_TYPE'   => "en_US.utf8"
}

set(:user) do
  Capistrano::CLI.ui.ask "ssh username for #{deploy_host}: "
end

set(:install_gems) do
  Capistrano::CLI.ui.agree "Install missing gems? (Yes/No): "
end

set :rake, "bundle exec rake"

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :restart, :roles => :web do
    run "touch #{release_path}/tmp/restart.txt"
  end

  task :finalize_update, :roles => :web do
    run "RAILS_ENV=#{rails_env}"
    
    # Install missing gems
    if install_gems
      run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle install"
    end
    
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
    
    # Manually do this because Capistrano support is broken for Rails 4
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"

    # Create symlink for apache
    run "cd #{release_path}/public/plugit-rails/media; ln -s /data_ebs/media/dash"
    
    # Set permissions
    run "chmod -R g+w #{release_path}"
    run "cd #{release_path}; chmod 0666 log/#{rails_env}.log"
  end
end