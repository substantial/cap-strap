require 'cap-strap/helpers'
require 'capistrano/cli'

module Capistrano::CapStrap
  module RVM
    def self.load_into(configuration)
      configuration.load do

        _cset :default_ruby , "1.9.3"
        _cset :gemset, "global"
        _cset :rubies, ["1.9.3"]
        _cset(:user) { Capistrano::CLI.ui.ask("bootstrap root user: ") }
        _cset :global_gems, ["bundler"]

        default_run_options[:shell] = '/bin/bash'
        default_run_options[:pty] = true

        namespace :rvm do
          task :default do
            rvm.install_system_wide_rvm
            rvm.add_gemrc
            rvm.add_user_to_rvm_group
            rvm.install_default_ruby
            rvm.install_rubies
            rvm.create_default_gemset
          end

          task :install_system_wide_rvm do
            command = "curl -L https://get.rvm.io | #{sudo} bash -s head --without-gems=\"rubygems-bundler\""
            run command
          end

          task :install_default_ruby do
            rubies.each do |rubie|
              ruby, ruby_patch, ruby_options = ruby_and_patch(rubie)
              next unless ruby == default_ruby

              install_ruby_and_gems(ruby, ruby_patch, ruby_options)
              break
            end
          end
          after "rvm:install_default_ruby", "rvm:set_default_ruby"

          task :install_rubies do
            rubies.each do |rubie|
              ruby, ruby_patch, ruby_options = ruby_and_patch(rubie)

              install_ruby_and_gems(ruby, ruby_patch, ruby_options)
            end
          end

          task :create_default_gemset do
            run "#{sudo} #{CAP_STRAP_RVM_PATH} #{default_ruby} do rvm gemset create #{gemset}"
          end

          task :set_default_ruby do
            run "#{sudo} #{CAP_STRAP_RVM_PATH} #{default_ruby} do rvm #{default_ruby} --default"
          end

          task :add_user_to_rvm_group do
            add_user_to_group(user, "rvm")
          end

          task :add_gemrc do
            put gemrc, "gemrc"
            run "#{sudo} mv ~/gemrc /etc/"
          end
        end
      end
    end
  end
end
