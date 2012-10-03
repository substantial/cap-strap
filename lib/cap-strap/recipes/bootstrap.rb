require 'cap-strap/helpers'
require 'cap-strap/recipes/rvm'
require 'capistrano/cli'

module Capistrano::CapStrap
  module Bootstrap
    def self.load_into(configuration)
      rvm_packages = %w( build-essential openssl libreadline6 libreadline6-dev
          curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev
          libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf
          libc6-dev ncurses-dev automake libtool bison subversion )

      configuration.load do

        namespace :bootstrap do
          before 'rvm:install_system_wide_rvm', 'bootstrap:install_rvm_dependencies'

          _cset(:deploy_user, "deploy")
          _cset(:bootstrap_user) { Capistrano::CLI.ui.ask("bootstrap root user: ") }
          _cset(:bootstrap_password) { '' }
          _cset(:deploy_user_password) { '' }
          _cset(:bootstrap_keys) { [] }
          _cset(:known_hosts) { default_known_hosts }
          _cset(:packages) { [] }
          _cset :authorized_keys_file, ""
          _cset :deploy_key_file, ""

          set (:user) { bootstrap_user }
          set (:password) { bootstrap_password } unless bootstrap_password.empty?
          ssh_options[:keys] = bootstrap_keys unless bootstrap_keys.empty?

          desc "Bootstraps a fresh box. Install RVM, create the deploy user, upload keys."
          task :default do
            set (:user) { bootstrap_user }
            set (:password) { bootstrap_password } unless bootstrap_password.empty?
            ssh_options[:keys] = bootstrap_keys unless bootstrap_keys.empty?
            rvm.default
            bootstrap.create_deploy_user
            bootstrap.upload_deploy_authorized_keys
            bootstrap.add_known_hosts
            bootstrap.add_rvm_to_sudoers
            bootstrap.upload_deploy_key
            bootstrap.install_specified_packages
          end

          task :install_specified_packages do
            install_packages(packages)
          end

          task :create_deploy_user do
            create_user(deploy_user, deploy_user_password)
            add_user_to_group(deploy_user, "rvm")
            add_user_to_group(deploy_user, "admin")
          end

          desc "Upload authorized keys for the deploy_user. Override by setting :authorized_keys_file. This
          is the relative path from the project root"
          task :upload_deploy_authorized_keys do
            if authorized_keys_file.empty?
              puts "No authorized keys file, skipping"
            else
              begin
                authorized_keys_path = File.join(File.expand_path(Dir.pwd), authorized_keys_file)
                puts "************Looking for Authorized Keys at: #{authorized_keys_path}"
                authorized_keys = File.read(authorized_keys_file)
                put(authorized_keys, "authorized_keys", :mode => "0600")
                make_directory("/home/#{deploy_user}/.ssh", :mode => "0700")
                sudo "mv ~/authorized_keys /home/#{deploy_user}/.ssh/"
                sudo "chown -R #{deploy_user}:rvm /home/#{deploy_user}/.ssh"
              rescue Exception => e
                puts e
              end
            end
          end

          task :add_known_hosts do
            make_directory("/home/#{deploy_user}/.ssh", :mode => "0700")
            put(known_hosts, "known_hosts", :mode => "0644")
            sudo "mv ~/known_hosts /home/#{deploy_user}/.ssh/known_hosts"
            sudo "chown -R #{deploy_user}:rvm /home/#{deploy_user}/.ssh"
          end

          task :add_rvm_to_sudoers do
            add_group_to_sudoers("rvm")
          end

          task :install_rvm_dependencies do
            install_packages(rvm_packages)
          end

          desc "Uploads the id_rsa for the deploy user. Put the key under config/deploy-key and run."
          task :upload_deploy_key do
            if deploy_key_file.empty?
              puts "No deploy key specified, skipping"
            else
              begin
                deploy_key_path= File.join(File.expand_path(Dir.pwd), deploy_key_file)
                puts "************Looking for Deploy key at: #{deploy_key_path}"
                id_rsa = File.read(deploy_key_path)
                put(id_rsa, "id_rsa", :mode => "0600")
                make_directory("/home/#{deploy_user}/.ssh", :mode => "0700")
                sudo "mv ~/id_rsa /home/#{deploy_user}/.ssh/"
                sudo "chown -R #{deploy_user}:rvm /home/#{deploy_user}/.ssh"
              rescue Exception => e
                puts e
              end
            end
          end
        end
      end
    end
  end
end
