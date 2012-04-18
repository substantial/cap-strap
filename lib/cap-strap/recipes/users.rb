require 'cap-strap/helpers'

module Capistrano
  module Users
    def self.load_into(configuration)
      configuration.load do

        _cset(:remove_users) { Capistrano::CLI.ui.ask("List users for removal: ") }

        namespace :users do
          task :default do end

          desc "Removes users specified by -s remove_users=<users>. Use comma for multiple users.
                If no parameters are specified, it will prompt"
          task :remove do
            users = remove_users.split(%r{\,|\ })
            users.delete_if{|x| x ==''}
            users.each do |user|
              remove_user(user)
            end
          end

          task :create_deploy_user do
            sudo "useradd -g rvm -G admin -s /bin/bash -d /home/deploy -m deploy"
          end

          task :set_ownership do
            sudo "chown -R #{user}:#{group} #{deploy_to}"
          end
        end
      end
    end
  end
end
