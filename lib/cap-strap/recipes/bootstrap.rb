require 'cap-strap/helpers'

module Capistrano
  module Bootstrap
    def self.load_into(configuration)
      configuration.load do
        packages = %w( build-essential openssl libreadline6 libreadline6-dev
          curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev
          libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf
          libc6-dev ncurses-dev automake libtool bison subversion )

        namespace :deploy do
          desc "bootstraps a fresh box. Specify root user in commandline using -s user=<root>"
          task :bootstrap do
            install_packages(packages)
            rvm.default
            users.create_deploy_user
            deploy.upload_deploy_authorized_keys
            deploy.add_known_hosts
            deploy.add_rvm_to_sudoers
          end

           task :upload_deploy_authorized_keys do
             sudo 'mkdir -p /home/deploy/.ssh'
             sudo 'chmod 0700 /home/deploy/.ssh'
             put(authorized_keys, "authorized_keys", :mode => "0600")
             sudo "mv ~/authorized_keys /home/deploy/.ssh/"
             sudo 'chown -R deploy:rvm /home/deploy/.ssh'
           end

           task :add_known_hosts do
             put(known_hosts, "known_hosts", :mode => "0644")
             sudo "mv ~/known_hosts /home/deploy/.ssh/known_hosts"
             sudo 'chown -R deploy:rvm /home/deploy/.ssh'
           end

           task :add_rvm_to_sudoers do
              sudo "echo %rvm ALL=NOPASSWD:ALL >> /etc/sudoers"
           end
        end

        after 'deploy:setup', 'users:set_ownership'
        end
    end
  end
end

