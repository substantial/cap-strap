require 'capistrano'

require 'minitest/autorun'
require 'minitest/capistrano'
require 'minitest/colorize'
require 'mocha'

require 'cap-strap'


def load_capistrano_recipe(recipe)
  before do
    @config = Capistrano::Configuration.new
    @config.extend(MiniTest::Capistrano::ConfigurationExtension)
    @orig_config = Capistrano::Configuration.instance
    Capistrano::Configuration.instance = @config
    recipe.send(:load_into, @config)
  end

  after do
    Capistrano::Configuration.instance = @orig_config
  end

  subject {@config}
  let(:recipe) { @config }
end
