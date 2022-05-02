server "2.22.222.33", roles: [:app, :web, :db], :primary => true,
rails_env: 'staging',
use_sudo: true,
user: 'ubuntu',
group: 'www-data',
ssh_options: {
	forward_agent: true
}

set :user, 'ubuntu'
set :use_sudo, true
set :deploy_to, "/srv/p4"
set :rails_env, "staging"
set :deploy_env, "staging"
set :branch, 'staging'


#after "deploy:updating", "sym_links:update"
after "deploy:symlink:shared",  "sym_links:update"
#after "deploy", "sym_links:update"

after "deploy", "phpfpm:restart"
