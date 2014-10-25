$preseed= <<SCRIPT
export DEBIAN_FRONTEND=noninteractive

echo "Pre-install nginx php mysql"

apt-get update
apt-get install -y python-software-properties
sudo add-apt-repository ppa:ondrej/php5-oldstable
apt-get update
apt-get install -y php5-fpm php5-cli nginx mysql-server php5-mysql curl php5-memcached php5-curl php5-memcache memcached

echo "Pre-install Node, Bower, Grunt"
test -x /usr/local/bin/node || {
  cd /usr/local/src
  wget --quiet http://nodejs.org/dist/v0.10.28/node-v0.10.28-linux-x64.tar.gz
  tar -zxvf node-v0.10.28-linux-x64.tar.gz
  cd /usr/local/bin
  ln -s /usr/local/src/node-v0.10.28-linux-x64/bin/node
  ln -s /usr/local/src/node-v0.10.28-linux-x64/bin/npm
  npm install -g bower grunt-cli grunt uglify-js uglifycss
} &>/dev/null

echo "Pre-install git"
apt-get install -y git &>/dev/null

echo "Setup project directory"
test -d /var/www/ws-orpgl || {
  sudo mkdir -p /var/www/ws-orpgl
  chown vagrant.vagrant /var/www/ws-orpgl
} &>/dev/null

echo "Pre-install composer"
test -x /usr/local/bin/composer || {
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/opt
  sudo ln -s /opt/composer.phar /usr/local/bin/composer
}
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'hashicorp/precise64'
  config.vm.network 'forwarded_port', guest: 80, host: 8080
  config.vm.network 'forwarded_port', guest: 3306, host: 33060
  config.vm.network 'forwarded_port', guest: 8081, host: 8081

  config.vm.provider 'virtualbox' do |v|
    v.memory = 4096
    v.cpus   = 2
  end
 
  config.ssh.forward_agent = true
 
  config.vm.provision :shell, inline: $preseed 
  config.vm.synced_folder "dev", "/var/www/dev",  :mount_options => ["dmode=777,fmode=777"]
end
