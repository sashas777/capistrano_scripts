role :web, %w{127.0.0.1},
rails_env: 'production',
use_sudo: true,
user: 'ubuntu',
ssh_options: {
	forward_agent: true
}

set :user, 'root'
set :use_sudo, true
set :deploy_to, "/srv/p1"
set :rails_env, "production"
set :deploy_env, "production"
set :branch, 'master'

before 'deploy', 'magento2:set'
before 'deploy:symlink:shared', 'magento2:compile'
after 'deploy', 'restart:phpfpm7'
after 'deploy', 'magento2:permissions'
after 'deploy', 'restart:varnish'
