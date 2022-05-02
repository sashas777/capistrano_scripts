server "localhost",
roles: [:app, :web, :db],
:primary => true,
rails_env: 'staging',
use_sudo: true,
user: 'ubuntu',
ssh_options: {
	forward_agent: true
}

set :user, 'root'
set :use_sudo, true 
set :deploy_to, "/srv/p5"
set :rails_env, "staging"
set :deploy_env, "staging"
set :branch, 'stage2'

before 'deploy', 'restart:set'
before 'deploy:symlink:shared', 'restart:compile'
after 'deploy', 'restart:phpfpm'
after 'deploy', 'restart:symlinks'
after 'deploy', 'restart:permission'
