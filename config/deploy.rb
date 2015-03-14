#lock '3.2.1'

set :application, 'ws-orpgl'
set :repo_url, 'git@github.com:mebyz/ws-orpgl.git'
set :branch, 'master'
set :use_sudo, false
set :deploy_to, "/var/www/#{fetch(:application)}"
set :ssh_options, { :forward_agent => true }
#set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :linked_dirs, %w{node_modules}
set :keep_releases, 12
set :grunt_flags, '--no-color'
set :composer_install_flags, ''

  task :release_installation do
    on roles :all do
        sudo "sudo rm -rf /var/www/dev/source && echo \"Fetches and installs release folder for this app\""
#       sudo "echo ".." && cdir=$(ls -td /var/www/ws-orpgl/releases/* | head -n1) && sudo rm -rf /var/www/release && sudo mkdir /var/www/release && sudo cp -r $cdir/* /var/www/release/"
	sudo "echo \"..\" && cdir=$(ls -td /var/www/ws-orpgl/releases/* | head -n1) && sudo rm -rf /var/www/release && sudo cp -rpH $cdir /var/www/release/"
#	sudo "mkdir /var/www/release"
        sudo "chmod -R 777 /var/www/release/web"
	sudo "cp /vagrant/app_dev.php.sav /var/www/release/web/app_dev.php"
    end
  end

 task :release_fpm do
    on roles :all do
        sudo "echo \"Install fpm configuration file\""
        sudo "cp /vagrant/www.conf.sav /etc/php5/fpm/pool.d/www.conf"
  end
 end

 task :release_webserver do                                                                                 
   on roles :all do                                                                                        
       sudo "echo \"Install nginx configuration file:\""                                                   
       sudo "cp /vagrant/default.sav /etc/nginx/sites-enabled/default"                                     
   end                                                                                                     
 end                                                                                                       

 task :release_database do
    on roles :all do
        sudo "echo \"Imports Dataset\""
        sudo "echo \"drop database IF EXISTS orpgl ;create database orpgl\" | sudo mysql -u root && sudo mysql -h localhost -u root orpgl < /vagrant/fixture.sql"
  end
 end
                                                                                                           
 task :release_reload do
    on roles :all do
        sudo "echo \"Restarts webserver+fpm\""
        sudo "service php5-fpm restart && sudo chmod go+rw /var/run/php5-fpm.sock && sudo service nginx restart"
	sudo "echo \"Clean Cache\" && cd /var/www/release/ && ./cleancache"
    end
  end

 task :release_cp do
    on roles :all do
	sudo "rm -rf /var/www/dev/source && sudo cp -frpH /var/www/release/ /var/www/dev/source/ 2>/dev/null || :"
   end
  end

 task :release_launch do
    on roles :all do  
      sudo "echo \"Launch\" && cd /var/www/dev/source && nohup php app/console ws:launch &"
    end
  end


task :release_gitconfig do
    on roles :all do
	sudo "echo \"git ignore chmod\" && cd /var/www/dev/source && git config core.fileMode false"
    end
end

task :composer_update do
    on roles :all do
        sudo "echo \"..\" && cdir=$(ls -td /var/www/ws-orpgl/releases/* | head -n1) && cd $cdir && sudo chmod 777 vendor/ && echo \"composer UPDATE\" && sudo /usr/bin/env composer config -g github-oauth.github.com c4e782683c73c5ba2801153a2bef76ed0fb9cf06 && sudo /usr/bin/env composer update  && sudo chmod 777 vendor/  "
    end
end

#after 'deploy:updated', 'grunt'
set :keep_releases, 1
after "deploy:updated", "deploy:cleanup" 
before 'composer:install', 'composer_update'
after 'deploy:updated', 'composer:install'
after 'deploy:updated', 'grunt'
after 'deploy:updated', 'release_installation'
after 'deploy:updated', 'release_fpm'
after 'deploy:updated', 'release_webserver'
after 'deploy:updated', 'release_database'
after 'deploy:updated', 'release_reload'
after 'deploy:updated', 'release_cp'
after 'deploy:updated', 'release_launch'
after 'deploy:updated', 'release_gitconfig'
