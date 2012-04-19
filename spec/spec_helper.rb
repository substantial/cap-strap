require 'capistrano'
require 'cap-strap'

require 'capistrano-spec'

Rspec.configure do |config|
  config.include Capistrano::Spec::Matchers
end
