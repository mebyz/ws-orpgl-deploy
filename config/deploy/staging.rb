server 'default', roles: %w{web app}

system "vagrant ssh-config > #{Dir.pwd}/vagrant-ssh-config"
set :ssh_options, {
  config: "#{Dir.pwd}/vagrant-ssh-config"
}
