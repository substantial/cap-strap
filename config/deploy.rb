require 'cap-strap'

server "localhost", :test

set :port, 2222

set :user, "vagrant"
set :password, "vagrant"

set :default_ruby, "1.9.3-p125"
set :gemset, "build-agent"
set :rubies, [ {
                :version => "1.9.3-perf",
                :patch => "falcon,debug --force-autoconf -j 3"
              } ]

set :deploy_user, "deploy"
set :group, "rvm"
set :authorized_keys_file, "config/test-authorized-keys"
set :deploy_key_file, "config/test-deploy-key"
