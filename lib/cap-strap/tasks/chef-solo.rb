Capistrano::Configuration.instance.load do
  namespace :chef_solo do
    task :default do
      chef_librarian.install
      chef_solo.install
    end

    task :install do
      servers = find_servers_for_task(current_task)
      servers.each do |s|
        command = ". /etc/profile.d/rvm.sh && "
        command << "cd #{current_release} && "
        command << "rvm use #{default_ruby}@#{gemset} && "
        command << "rvmsudo chef-solo -c #{current_release}/.chef/solo.rb -j #{current_release}/.chef/node.json -N #{s.options[:node_name]}"
        run command
      end
    end
  end

  namespace :chef_librarian do
    task :default do
      chef_librarian.install
    end

    task :install do
      command = ". /etc/profile.d/rvm.sh && "
      command << "cd #{current_release} && "
      command << "rvm use #{default_ruby}@#{gemset} && "
      command << "bundle exec librarian-chef install"
      run command
    end
  end

  namespace :deploy do
    task :symlink_cookbooks do
      shared_dir = File.join(shared_path, 'cookbooks')
      release_dir = File.join(current_release, 'cookbooks')
      run "mkdir -p #{shared_dir}; ln -s #{shared_dir} #{release_dir}"
    end
  end

  after 'chef:default', 'deploy:symlink_cookbooks'
  after 'deploy:update_code', 'chef:default'
end
