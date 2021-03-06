require 'capistrano'

require 'cap-strap/helpers'
require "cap-strap/recipes/rvm"
require "cap-strap/recipes/bootstrap"

if instance = Capistrano::Configuration.instance
  Capistrano::CapStrap::RVM.load_into(instance)
  Capistrano::CapStrap::Bootstrap.load_into(instance)

  instance.load do
    ssh_options[:forward_agent] = true
  end
end
