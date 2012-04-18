require 'capistrano'
require 'cap-strap'

require 'capistrano-spec'

require 'pry'

Rspec.configure do |config|
  config.include Capistrano::Spec::Matchers
end
