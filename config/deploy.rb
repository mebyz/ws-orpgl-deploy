lock '3.2.1'

set :application, 'ws-orpgl'
set :repo_url, 'git@github.com:mebyz/ws-orpgl.git'
set :branch, 'master'
set :use_sudo, false
set :deploy_to, "/var/www/#{fetch(:application)}"
set :ssh_options, { :forward_agent => true }
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :linked_dirs, %w{node_modules}
set :keep_releases, 12
set :grunt_flags, '--no-color'
set :composer_install_flags, ''

  task :release_installation do
    on roles :all do
        sudo "echo \"Fetches and installs release folder for this app\""
        sudo "rm -f /var/www/release && cdir=$(ls -td /var/www/ws-orpgl/releases/* | head -n1) && sudo ln -s $cdir /var/www/release"
        sudo "chmod -R 777 /var/www/release/web"
    end
  end

 task :release_fpm do
    on roles :all do
        sudo "echo \"Install fpm configuration file\""
        sudo "cp /vagrant/www.conf.sav /etc/php5/fpm/pool.d/www.conf"
  end
 end

 task :release_reload do
    on roles :all do
        sudo "echo \"Restarts webserver+fpm\""
	#sudo "ln -fs /vagrant/config/nginx.conf /etc/nginx/sites-enabled/default"
        sudo "service php5-fpm restart && sudo chmod go+rw /var/run/php5-fpm.sock && sudo service nginx restart"
    end
  end

after 'deploy:updated', 'composer:install'
after 'deploy:updated', 'release_installation'
after 'deploy:updated', 'release_fpm'
after 'deploy:updated', 'release_reload'
