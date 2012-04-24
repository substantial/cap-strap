# cap-strap

  cap-strap is a Capistrano Extension that bootstraps a machine for future capistrano tasks.
It installs System-wide RVM and specified rubies and gems. It will create a deploy user, upload authorized_keys and
deploy key.

## Notes

Currently cap-strap has only been tested on Ubuntu 10.04 and 10.10.


## Installation

Add this line to your application's Gemfile:

    gem 'cap-strap'

And then execute:

    $ bundle

## Usage

You will be prompted for the name of the future deploy_user, location of authorized keys and
the deploy user's deploy_key. Deploy key isn't required, and you may skip.

You may re-run the deploy_key task by `$ cap <stage> bootstrap:upload_deploy_key`

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
