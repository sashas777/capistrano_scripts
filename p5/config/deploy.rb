# base
set :application, 'TEST5'
set :repo_url, 'git@github.com:test/p5.git'
set :linked_dirs, fetch(:linked_dirs, []).push('log')

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
    		execute "/var/www/httpsdocs/bin/magento cache:clean"
        	execute "sudo service varnish restart"
        end
	end
	
	task :symlinks do
		on roles(:web) do
			# execute "ln -s /srv/p5/shared/env.php /var/www/httpsdocs/app/etc"
			# execute "ln -s /srv/p5/shared/media /var/www/httpsdocs/pub"
			# execute "ln -s /srv/p5-nyc/shared/var /var/www/httpsdocs"
		end
	end
	task :compile do
		on roles(:web) do
                        execute "#{release_path}/httpsdocs/bin/magento maintenance:enable"
			execute "sudo rm -rf /srv/p5/shared/var/di"
			execute "ln -s /srv/p5/shared/env.php #{release_path}/httpsdocs/app/etc"
			execute "ln -s /srv/p5/shared/media #{release_path}/httpsdocs/pub"
			execute "ln -s /srv/p5/shared/log #{release_path}/httpsdocs/var"
			execute "#{release_path}/httpsdocs/bin/magento setup:upgrade"
                        execute "#{release_path}/httpsdocs/bin/magento cache:flush"
                        execute "#{release_path}/httpsdocs/bin/magento setup:di:compile"
                        execute "sudo chown -R www-data:www-data /var/www/httpsdocs/var"
			execute "#{release_path}/httpsdocs/bin/magento setup:static-content:deploy"
			execute "sudo chown -R www-data:www-data /var/www/httpsdocs/pub"
                        execute "#{release_path}/httpsdocs/bin/magento indexer:reindex"
                        execute "#{release_path}/httpsdocs/bin/magento maintenance:disable"

		end
	end
	task :permission do
		on roles(:web) do
			execute "sudo chown -R www-data:www-data /var/www/httpsdocs/app/etc"
			execute "sudo chown -R www-data:www-data /var/www/httpsdocs/var"
			execute "sudo chown -R www-data:www-data /var/www/httpsdocs/pub"
		end
	end
	
	task :set do
		on roles(:web) do
			execute "sudo chown -R ubuntu:ubuntu /var/www/httpsdocs/app/etc"
		end
	end
	task :test do
		on roles(:web) do
			execute "cd #{release_path}"
		end
	end
end
