# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "kls"
set :repo_url, "git@github.com:test/p4.git"

# git
set :deploy_via, :remote_cache
set :scm, :git
set :keep_releases, 2


namespace :sym_links do
  task :update do
   on roles(:web) do
    execute "sudo chown -R ubuntu:www-data  /srv/p4/shared/log/"
    execute "ln -s /srv/p4/shared/media #{release_path}/httpsdocs/"
    execute "ln -s /srv/p4/shared/xmlservice #{release_path}/httpsdocs/var/xmlservice"
    execute "ln -s /srv/p4/shared/local.xml #{release_path}/httpsdocs/app/etc/"
    execute "ln -s #{release_path}/static/dist  #{release_path}/httpsdocs/static"
    execute "ln -s /srv/p4/shared/log #{release_path}/httpsdocs/var/log"

    execute "cd #{release_path}/build/frontend; sudo npm install --silent"
    execute "sudo chown -R  ubuntu:ubuntu /home/ubuntu/.config/"

    execute "cd #{release_path}/build/frontend; bower install"
    execute "cd #{release_path}/build/frontend; sudo grunt"
#    execute "sudo touch /var/ngx_pagespeed_cache/cache.flush"

    execute "sudo chmod 775 -R  #{release_path}/build/frontend"

    execute "sudo chown -R www-data:www-data #{release_path}"
    execute "sudo chmod 777 -R  #{release_path}/httpsdocs/var"
   execute "sudo chmod 777 -R  /srv/p4/current/httpsdocs/var"
   execute "sudo chown ubuntu:www-data  -R  /srv/p4/current/"
   end
  end
end

after "deploy", "phpfpm:restart"
namespace :phpfpm do
  task :restart do
   on roles(:web) do
    execute "sudo service php5-fpm restart"
    execute "sudo service memcached restart"
   end
  end
end

