require 'cap-strap'

server "localhost", :test

set :port, 2222

set :bootstrap_user, "vagrant"
set :bootstrap_password, "vagrant"

set :gemset, "build-agent"
set :rubies, [
  "1.9.3-p125",
  {
    :version => "1.9.3-p125-perf",
    :patch => "falcon,debug --force-autoconf -j 3"
  }
]

set :default_ruby, "1.9.3-p125-perf"

set :deploy_user, "deploy"
set :group, "rvm"
set :authorized_keys_file, "config/test-authorized-keys"
set :deploy_key_file, "config/test-deploy-key"
