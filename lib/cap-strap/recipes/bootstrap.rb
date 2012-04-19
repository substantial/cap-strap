require 'cap-strap/helpers'
require 'cap-strap/recipes/rvm'
require 'capistrano/cli'

module Capistrano
  module Bootstrap
    def self.load_into(configuration)
      configuration.load do
        before 'rvm:install_system_wide_rvm', 'bootstrap:install_rvm_dependencies'

        rvm_packages = %w( build-essential openssl libreadline6 libreadline6-dev
          curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev
          libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf
          libc6-dev ncurses-dev automake libtool bison subversion )

        _cset(:deploy_user) { Capistrano::CLI.ui.ask("deploy user: ") }
        _cset(:user) { Capistrano::CLI.ui.ask("bootstrap root user: ") }
        _cset(:authorized_keys_file) { Capistrano::CLI.ui.ask("Location of authorized keys to upload: ") }
        _cset(:deploy_key_file) { Capistrano::CLI.ui.ask("Location of deploy key for upload: ") }
        _cset(:known_hosts) { default_known_host }

        namespace :bootstrap do
          desc "bootstraps a fresh box."
          task :default do
            rvm.default
            bootstrap.create_deploy_user
            bootstrap.upload_deploy_authorized_keys
            bootstrap.add_known_hosts
            bootstrap.add_rvm_to_sudoers
            bootstrap.upload_deploy_key
          end

          task :create_deploy_user do
            create_user(deploy_user, "rvm", "admin")
          end

          task :upload_deploy_authorized_keys do
            begin
              authorized_keys = File.read(authorized_keys_file)
              put(authorized_keys, "authorized_keys", :mode => "0600")
              sudo "mkdir -p /home/#{deploy_user}/.ssh"
              sudo "chmod 0700 /home/#{deploy_user}/.ssh"
              sudo "mv ~/authorized_keys /home/#{deploy_user}/.ssh/"
              sudo "chown -R #{deploy_user}:rvm /home/#{deploy_user}/.ssh"
            rescue Exception => e
              puts e
            end
           end

           task :add_known_hosts do
             put(known_hosts, "known_hosts", :mode => "0644")
             sudo "mv ~/known_hosts /home/#{deploy_user}/.ssh/known_hosts"
             sudo "chown -R deploy:rvm /home/#{deploy_user}/.ssh"
           end

           task :add_rvm_to_sudoers do
              sudo "echo %rvm ALL=NOPASSWD:ALL >> /etc/sudoers"
           end

          task :install_rvm_dependencies do
            install_packages(rvm_packages)
          end

          desc "Uploads the id_rsa for the deploy user. Put the key under config/deploy-key and run."
          task :upload_deploy_key do
            begin
              id_rsa = File.read(deploy_key_file)
              put(id_rsa, "/home/#{deploy_user}/.ssh/id_rsa", :mode => "0600")
            rescue Exception => e
              puts e
            end
          end
        end
      end
    end
  end
end
