server "staging.p2.sashas.org", roles: [:app, :web, :db], :primary => true,
rails_env: 'staging',
use_sudo: true,
user: 'ubuntu',
ssh_options: {
	forward_agent: true
}

set :user, 'ubuntu'
set :use_sudo, true
set :deploy_to, "/srv/p2"
set :rails_env, "staging"
set :deploy_env, "staging"
set :branch, 'staging'

before 'deploy:symlink:shared', 'magento2:compile'
after 'deploy', 'magento2:flush_cache'
after 'deploy', 'magento2:permissions'
after 'deploy', 'restart:phpfpm7'
