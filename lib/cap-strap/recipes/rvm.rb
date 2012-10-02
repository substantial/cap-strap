require 'cap-strap/helpers'
require 'capistrano/cli'

module Capistrano::CapStrap
  module RVM
    def self.load_into(configuration)
      configuration.load do

        _cset :default_ruby , "1.9.3-p125"
        _cset :gemset, "global"
        _cset :rubies, ["1.9.3-p125"]
        _cset(:user) { Capistrano::CLI.ui.ask("bootstrap root user: ") }
        _cset :global_gems, ["bundler"]

        default_run_options[:shell] = '/bin/bash'
        default_run_options[:pty] = true

        namespace :rvm do
          task :default do
            rvm.install_system_wide_rvm
            rvm.add_gemrc
            rvm.add_user_to_rvm_group
            rvm.install_rubies
            rvm.set_default_ruby
            rvm.create_default_gemset
          end

          task :install_system_wide_rvm do
            command = "curl -L get.rvm.io | "
            command << "#{sudo} bash -s stable"
            run command
          end

          task :install_rubies do
            rubies.each do |rubie|
              if rubie.is_a?(Hash)
                ruby = rubie.fetch(:version)
                ruby_patch = rubie.fetch(:patch)
              else
                ruby = rubie
                ruby_patch = nil
              end
              install_ruby(ruby, ruby_patch)
              global_gems.each do |gem|
                install_global_gem(ruby, gem)
              end
            end
          end

          task :create_default_gemset do
            run "#{sudo} #{rvm_wrapper("rvm use #{default_ruby}@#{gemset} --create")}"
          end

          task :set_default_ruby do
            sudo rvm_wrapper("rvm use #{default_ruby} --default")
          end

          task :add_user_to_rvm_group do
            add_user_to_group(user, "rvm")
          end

          task :add_gemrc do
            put gemrc, "gemrc"
            sudo "mv ~/gemrc /etc/"
          end
        end
      end
    end
  end
end
