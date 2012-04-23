require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Capistrano::CapStrap::Bootstrap do
  load_capistrano_recipe(Capistrano::CapStrap::Bootstrap)

  describe "default variables" do
    before do
      Capistrano::CLI.ui.stubs(:ask).returns('prompt')
    end

    it "prompts for a bootstrap user" do
      recipe.fetch(:user).must_equal 'prompt'
    end

    it "prompts for a deploy user" do
      recipe.fetch(:deploy_user).must_equal 'prompt'
    end

    it 'prompts for authorized keys if no path set' do
      recipe.fetch(:authorized_keys_file).must_equal 'prompt'
    end

    it "prompts for deploy key location if not set" do
      recipe.fetch(:deploy_key_file).must_equal 'prompt'
    end
  end

  describe "variables set" do
    before do
      recipe.set(:user, "foo")
      recipe.set(:deploy_user, "bar")
      recipe.set(:known_hosts, "baz")
    end

    it "doesn't prompted for a bootstrap user" do
      recipe.fetch(:user).must_equal "foo"
    end

    it "doesn't prompted for a deploy user" do
      recipe.fetch(:deploy_user).must_equal "bar"
    end

    it "replaces known_hosts with ones that are set" do
      recipe.fetch(:known_hosts).must_equal "baz"
    end
  end

  describe "callbacks" do
    it "installs rvm dependencies before installing system rvm" do
      recipe.must_have_callback_before "rvm:install_system_wide_rvm", "bootstrap:install_rvm_dependencies"
    end
  end
end
