role :web, %w{12.2.2.2},
rails_env: 'staging',
use_sudo: true,
user: 'ubuntu',
ssh_options: {
  forward_agent: true
}

set :user, 'root'
set :use_sudo, true
set :deploy_to, "/srv/p3"
set :rails_env, "staging"
set :deploy_env, "staging"
set :branch, 'stage'

before 'deploy', 'restart:set'
before 'deploy:symlink:shared', 'restart:compile'
after 'deploy', 'restart:phpfpm7'
after 'deploy', 'restart:permission'
after 'deploy', 'restart:varnish'
