require 'spec_helper'

describe Capistrano::Bootstrap do
  let(:ui) { double("ui", :ask => 'prompt') }
  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)
    Capistrano::Bootstrap.load_into(@configuration)
    Capistrano::CLI.stub(:ui).and_return { ui }
  end

  describe "default variables" do
    it "prompts for a bootstrap user" do
      @configuration.fetch(:user).should == 'prompt'
    end
    it "prompts for a deploy user" do
      @configuration.fetch(:deploy_user).should == 'prompt'
    end
  end

end
