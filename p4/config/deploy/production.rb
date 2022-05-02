server "2.2.2.22", roles: [:app, :web, :db], :primary => true,
rails_env: 'production',
use_sudo: true,
user: 'ubuntu',
group: 'www-data',
ssh_options: {
        forward_agent: true
}

set :user, 'ubuntu'
set :use_sudo, true
set :deploy_to, "/srv/p4"
set :rails_env, "production"
set :deploy_env, "production"
set :branch, 'master'


#after "deploy:updating", "sym_links:update"
after "deploy:symlink:shared",  "sym_links:update"
#after "deploy", "sym_links:update"

after "deploy", "phpfpm:restart"


