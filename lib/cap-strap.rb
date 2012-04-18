require "cap-strap/version"

require "cap-strap/ext/rvm"
require "cap-strap/ext/bootstrap"
require "cap-strap/ext/chef-solo"
require "cap-strap/ext/users"

configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

configuration.load do

  # User default settings
  _cset :user, "deploy"
  _cset :group, "rvm"

  # RVM default settings
  _cset :default_ruby , "1.9.3-p125"
  _cset :gemset, "global"
  _cset :rubies, []

  # Settings for bootstrap scripts to work
  default_run_options[:shell] = '/bin/bash'
  default_run_options[:pty] = true
  ssh_options[:forward_agent] = true

end
