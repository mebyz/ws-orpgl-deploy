set :git_strategy, GitCopyStrategy

server 'default', roles: %w{web app}

system "vagrant ssh-config > #{Dir.pwd}/vagrant-ssh-config"
set :ssh_options, {
  config: "#{Dir.pwd}/vagrant-ssh-config"
}

namespace :deploy do
  namespace :symlink do
    task :release do
      on release_roles :all do
        current_release = File.basename(release_path)

        within(deploy_path) do
          execute :rm, '-rf', 'dev'
          execute :ln, '-s', "releases/#{current_release}", 'dev'
        end
      end
    end
  end
end
