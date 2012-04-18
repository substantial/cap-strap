require 'spec_helper'

describe Capistrano::RVM do
  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)
    Capistrano::RVM.load_into(@configuration)
  end

  describe "default variables" do
    it "has a default user" do
      @configuration.fetch(:user).should be
    end

    it "has a default ruby" do
      @configuration.fetch(:default_ruby).should be
    end

    it "has a default gemset" do
      @configuration.fetch(:gemset).should be
    end

    it "defaults to empty ruby set" do
      @configuration.fetch(:rubies).length.should be 0
    end
  end

  describe "task #install_system_wide_rvm" do
    let(:command) { command = "curl -L get.rvm.io | sudo bash -s stable" }

    before do
      @configuration.find_and_execute_task("rvm:install_system_wide_rvm")
    end
    it "runs install command" do
      @configuration.should have_run command
    end
  end
end
