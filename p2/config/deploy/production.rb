#role :web, %w{127.1.1.11},
#rails_env: 'production',
#use_sudo: true,
#user: 'ubuntu',
#ssh_options: {
#	forward_agent: true
#}

#set :user, 'root'
#set :use_sudo, true
#set :deploy_to, "/srv/p2"
#set :rails_env, "production"
#set :deploy_env, "production"
#set :branch, 'master'

#before 'deploy', 'restart:set'
#before 'deploy:symlink:shared', 'restart:compile'
#after 'deploy', 'restart:phpfpm7'
#after 'deploy', 'restart:permission'
#after 'deploy', 'restart:varnish'
