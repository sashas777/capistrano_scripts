server "staging.p1.sashasorg.org", roles: [:app, :web, :db], :primary => true,

user: 'ubuntu',
use_sudo: true,

ssh_options: {
	forward_agent: true
}

set :deploy_to, "/srv/p1"
set :branch, 'staging'

before 'deploy', 'magento2:set'
before 'deploy:symlink:shared', 'magento2:compile'
after 'deploy', 'restart:phpfpm7'
after 'deploy', 'magento2:permissions'
