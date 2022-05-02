# base
set :application, 'P1'
set :repo_url, 'git@github.com:test/test.git'
set :linked_dirs, fetch(:linked_dirs, []).push('log')

# git
set :deploy_via, :remote_cache
set :scm, :git
set :keep_releases, 3

# magento2 methods
namespace :magento2 do
	task :compile do
		on roles(:web) do
			execute "ln -s /srv//shared/env.php #{release_path}/public/app/etc"
			execute "ln -s /srv/p1/shared/media #{release_path}/public/pub"
			execute "ln -s /srv/p1/shared/log #{release_path}/public/var"
                        execute "sudo rm -rf #{release_path}/public/var/di"
                        execute "sudo rm -rf #{release_path}/public/var/cache"
                        execute "sudo rm -rf #{release_path}/public/var/page_cache"
                        execute "sudo rm -rf #{release_path}/public/var/generation"
                        execute "sudo rm -rf #{release_path}/public/var/view_preprocessed"
			execute "sudo chmod u+x #{release_path}/public/bin/magento"
                        execute "#{release_path}/public/bin/magento maintenance:enable"
			execute "#{release_path}/public/bin/magento setup:upgrade"
                        execute "#{release_path}/public/bin/magento cache:flush"
                        execute "#{release_path}/public/bin/magento setup:di:compile"
                        execute "sudo chown -R www-data:www-data /var/www/public/var"
			execute "#{release_path}/public/bin/magento setup:static-content:deploy"
                        execute "sudo chown -R www-data:www-data /var/www/public/pub"
                        execute "#{release_path}/public/bin/magento indexer:reindex"
                        execute "sudo chmod 777 -R  #{release_path}/public/pub"
                        execute "sudo chmod 777 -R #{release_path}/public/var"
                        execute "#{release_path}/public/bin/magento maintenance:disable"
		end
	end

	task :permissions do
		on roles(:web) do
                        execute "sudo chown -R www-data:www-data /var/www/public/app/etc"
                        execute "sudo chown -R www-data:www-data /var/www/public/var"
                        execute "sudo chown -R www-data:www-data /var/www/public/pub"
		end
	end

        task :set do
                on roles(:web) do
                        execute "sudo chown -R ubuntu:ubuntu /var/www/public/app/etc"
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
        	execute "sudo service varnish restart"
        end
	end	
end
