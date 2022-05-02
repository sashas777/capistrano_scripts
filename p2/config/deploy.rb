# base
set :application, 'P2'
set :repo_url, 'git@github.com:test/p2.git'
# set :linked_dirs, fetch(:linked_dirs, []).push('log')

# git
set :deploy_via, :remote_cache
set :scm, :git
set :keep_releases, 5

# magento2 methods
namespace :magento2 do
	task :compile do
		on roles(:web) do
			execute "sudo rm -rf /srv/p2/shared/var/di"
			execute "ln -s /srv/p2/shared/env.php #{release_path}/public/app/etc"
      execute "ln -s /srv/p2/shared/config.php #{release_path}/public/app/etc"
			execute "ln -s /srv/p2/shared/media #{release_path}/public/pub"
			execute "ln -s /srv/p2/shared/var #{release_path}/public/var"
			execute "/usr/bin/php #{release_path}/public/bin/magento setup:upgrade"
			execute "/usr/bin/php #{release_path}/public/bin/magento setup:di:compile"
			execute "/usr/bin/php #{release_path}/public/bin/magento setup:static-content:deploy"
		end
	end

	task :permissions do
		on roles(:web) do
			execute "chmod g+w /var/www/public/pub"
			execute "sudo chown -R www-data:www-data /var/www/public/var"
			execute "sudo chmod -R 777 /var/www/public/var"
		end
	end

	task :flush_cache do
		on roles(:web) do
			execute "/usr/bin/php /var/www/public/bin/magento cache:clean"
			execute "/usr/bin/php /var/www/public/bin/magento cache:flush"
		end
	end
end

# restart methods
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

	task :phpfpm7 do
    	on roles(:web) do
        	execute "sudo service php7.0-fpm restart"
        end
	end
end
