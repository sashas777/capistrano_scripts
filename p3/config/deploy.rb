# base
set :application, 'p3'
set :repo_url, 'git@github.com:test/p3.git'
# set :linked_dirs, fetch(:linked_dirs, []).push('log')

# git
set :deploy_via, :remote_cache
set :scm, :git
set :keep_releases, 3

# restarting method
namespace :restart do
    task :memcache do
      on roles(:web) do
          execute "sudo service memcached restart"
        end
    end

    task :nginx do
      on roles(:web) do
          execute "sudo service nginx restart"
        end
  end

  task :phpfpm do
      on roles(:web) do
          execute "sudo service php5.6-fpm restart"
        end
  end
  task :phpfpm7 do
      on roles(:web) do
          execute "sudo service php7.0-fpm restart"
        end
  end
  task :solr do
      on roles(:web) do
      execute "sudo service apache-solr restart"
    end
  end
  task :varnish do
      on roles(:web) do
        execute "/var/www/html/bin/magento cache:clean"
        execute "sudo service varnish restart"
      end
  end

  task :symlinks do
    on roles(:web) do
      # execute "ln -s /srv/p3/shared/env.php /var/www/html/app/etc"
      # execute "ln -s /srv/p3/shared/media /var/www/html/pub"
      # execute "ln -s /srv/p3/shared/var /var/www/html"
    end
  end
  task :compile do
    on roles(:web) do
      execute "ln -s /srv/p3/shared/env.php #{release_path}/html/app/etc"
      execute "ln -s /srv/p3/shared/media #{release_path}/html/pub"
      execute "ln -s /srv/p3/shared/var #{release_path}/html"
      execute "#{release_path}/html/bin/magento maintenance:enable"
      execute "sudo rm -rf /srv/p3/shared/var/di"
      execute "sudo mkdir -p #{release_path}/html/pub/static"
      execute "sudo chmod 0777 #{release_path}/html/pub/static"
      execute "#{release_path}/html/bin/magento setup:upgrade"
      execute "#{release_path}/html/bin/magento cache:flush"
      execute "#{release_path}/html/bin/magento setup:di:compile"
      execute "#{release_path}/html/bin/magento setup:static-content:deploy"
      # execute "#{release_path}/html/bin/magento indexer:reindex"
      execute "#{release_path}/html/bin/magento maintenance:disable"
      execute "sudo chown -R www-data:www-data /var/www/html"

    end
  end
  task :permission do
    on roles(:web) do
    #	execute "sudo chown -R www-data:www-data #{release_path}/html/var/www/html/app/etc"
      execute "sudo chown -R www-data:www-data /var/www/html/var"
      execute "sudo chown -R www-data:www-data /var/www/html/pub"
      execute "sudo chmod 777 -R /var/www/html/var/ /var/www/html/pub"
    end
  end

  task :set do
    on roles(:web) do
      execute "sudo chown -R ubuntu:ubuntu /var/www/html"
    end
  end
  task :test do
    on roles(:web) do
      execute "cd #{release_path}"
    end
  end
end
