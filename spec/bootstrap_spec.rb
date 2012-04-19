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

    it 'prompts for authorized keys if no path set' do
      @configuration.fetch(:authorized_keys_file).should == 'prompt'
    end

    it "prompts for deploy key location if not set" do
      @configuration.fetch(:deploy_key_file).should == 'prompt'
    end
  end

  describe "variables set" do
    before do
      @configuration.set(:user, "foo")
      @configuration.set(:deploy_user, "bar")
      @configuration.set(:known_hosts, "baz")
    end

    it "doesn't prompted for a bootstrap user" do
      @configuration.fetch(:user).should == "foo"
    end

    it "doesn't prompted for a deploy user" do
      @configuration.fetch(:deploy_user).should == "bar"
    end

    it "replaces known_hosts with ones that are set" do
      @configuration.fetch(:known_hosts).should == "baz"
    end
  end
end
