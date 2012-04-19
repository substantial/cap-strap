# CapStrap

  CapStrap is a Capistrano Extension that bootstraps a machine for future capistrano tasks.
It installs System-wide Rvm and specified rubies and gems. It will create a user for future capistrano
deploy tasks.

## Notes

Currently only Ubuntu 10.04 and 10.10 have been tested.


## Installation

Add this line to your application's Gemfile:

    gem 'cap-strap', :git => 'git@github.com:substantial/cap-strap.git'

And then execute:

    $ bundle

## Usage

You will be prompted for the name of the future deploy_user, location of authorized keys and
the deploy_key. Deploy key isn't required, and you may skip.

In your deploy.rb, you may override the following variables:
Note: Paths are relative to the root

* `set :deploy_user, "<name of user for future deployes>"`
* `set :authorized_keys_file, "<location of authorized keys>"`
* `set :deploy_key_file, "<location of deploy-key>"`
* `set :known_hosts, "<string of known hosts">` - Default is github.com
* `set :default_ruby, "1.9.3-p125"` - Default is 1.9.3-p125
* `set :rubies, [
                  "ree-1.8.7-2012.02",
                  {
                    :version => "1.9.3-p125-perf",
                    :patch => "falcon,debug --force-autoconf -j 3"
                  }
                ]`
* `set :gemset, "<default gemset>"` - Default is global
* `set :global_gems, ["bundler", "other-gem"]` - Default is ["bundler"]

Note: Run from project root

    $ cap <stage> bootstrap -s user=<root_username>

## Testing

 We're https://github.com/technicalpickles/capistrano-spec for testing the capistrano
configuration.

###TODO: Use Vagrant to test cap-strap.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
