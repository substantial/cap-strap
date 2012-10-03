# cap-strap

  cap-strap is a Capistrano Extension that bootstraps a machine for future capistrano tasks.
It installs System-wide RVM and specified rubies and gems. It will create a deploy user, upload authorized_keys and
deploy key.

## Notes

Currently cap-strap has only been tested on Ubuntu 10.04 and 10.10, 12.04.

## Installation

Add this line to your application's Gemfile:

    gem 'cap-strap'

And then execute:

    $ bundle

## Usage

####Upload deploy_key for deploy_user
Set the relative path to the deploy_key and run:
 `$ cap <stage> bootstrap:upload_deploy_key`

####Upload authorized keys for deploy_user
Set the relative path to the deploy_key and run:
  `$cap <stage> bootstrap:upload_authorized_keys`

In your deploy.rb, you may override the following variables:

You may specificy any additional packages for installation by setting the :packages.

Note: Paths are relative to the root

``` ruby
set :bootstrap_user, "<name of root user for bootstraping>" # default: prompt for user input
set :bootstrap_password, "<password associated with the root user>" # default: empty string
set :bootstrap_keys, "<array containing path to ssh keys>" # default: empty array
set :deploy_user, "<name of user for future deployes>" # default: 'deploy'
set :deploy_user_password, "<password for deploy user>" # default: skips. Recommend using authorized keys
set :authorized_keys_file, "<location of authorized keys>" # skips if not specified
set :deploy_key_file, "<location of deploy-key>" # skips if not specified
set :known_hosts, "<string of known hosts"> # default: github.com
set :default_ruby, "1.9.3-p125" # default: '1.9.3-p125'
set :rubies, [
                "ree-1.8.7-2012.02",
                {
                  :version => "1.9.3-p125-perf",
                  :patch => "falcon,debug --force-autoconf -j 3"
                }
              ]
set :gemset, "<default gemset>" # default 'global'
set :global_gems, ["bundler", "other-gem"] # default: ["bundler"]
set :packages, ["git", "vim"] # default: []
```

Note: Run from project root

    $ cap <stage> bootstrap

## Testing

 We're https://github.com/fnichol/minitest-capistrano for testing the capistrano
configuration.

Running Tests:

* `rake test` - manually run the tests
* `bundle exec guard start` - Use guard to watch for changes and run tests automatically.

### Testing with Vagrant

Vagrant will fetch a lucid-64 box and boot it up. Once started, it will run
cap bootstrap on the vagrant box.

To run: `bundle exec rake vagrant_test`

To reload the box and run again: `bundle exec rake vagrant_test:restart`

Vagrant Notes:

* `vagrant ssh` - will ssh into the vagrant VM.
* lucid64 root user and password is "vagrant"
* vagrant box runs on port 2222
* `vagrant destroy` - will destroy the current vagrant VM. It doesn't remove the large downloaded box.

For more information regarding Vagrant: http://vagrantup.com/

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
