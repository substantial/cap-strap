require "cap-strap/version"

require 'capistrano'


require 'cap-strap/helpers'
require "cap-strap/recipes/rvm"
require "cap-strap/recipes/bootstrap"
require "cap-strap/recipes/users"


if instance = Capistrano::Configuration.instance
  Capistrano::RVM.load_into(instance)
  Capistrano::Bootstrap.load_into(instance)
  Capistrano::Users.load_into(instance)

  instance.load do
    # User default settings
    _cset :user, "deploy"
    _cset :group, "rvm"

    # Settings for bootstrap scripts to work
    ssh_options[:forward_agent] = true
  end
end
