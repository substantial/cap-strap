require 'spec_helper'

describe Capistrano::Bootstrap do
  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)
    Capistrano::Bootstrap.load_into(@configuration)
  end

  describe "default variables" do
    it "has a user" do
      @configuration.fetch(:user).should be
    end
    it "has a deploy_user" do
      @configuration.fetch(:deploy_user).should be
    end
  end

end
