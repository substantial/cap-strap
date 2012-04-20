require 'spec_helper'

describe Capistrano::RVM do
  let(:ui) { double("ui", :ask => 'prompt') }
  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)
    Capistrano::RVM.load_into(@configuration)
    Capistrano::CLI.stub(:ui).and_return { ui }
  end

  describe "default variables" do
    it "has a prompts for a bootstrap user" do
      @configuration.fetch(:user).should == 'prompt'
    end

    it "has a default ruby" do
      @configuration.fetch(:default_ruby).should be
    end

    it "has a default gemset" do
      @configuration.fetch(:gemset).should be
    end

    it "has a rubie ruby set" do
      @configuration.fetch(:rubies).length.should be 1
    end

    it "ruby is the default rubie" do
      default_ruby = @configuration.fetch(:default_ruby)
      @configuration.fetch(:rubies).first.should == default_ruby
    end

    it "has bundler in it's global gems" do
      @configuration.fetch(:global_gems).include?("bundler").should == true
    end
  end
end
