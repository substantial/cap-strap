require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Capistrano::CapStrap::Bootstrap do
  load_capistrano_recipe(Capistrano::CapStrap::Bootstrap)

  before do
    Capistrano::CLI.ui.stubs(:ask).returns('prompt')
  end

  describe "tasks" do
   it "has a default task" do
    recipe.must_have_task "bootstrap:default"
   end

   it "has a create_deploy_user task" do
      recipe.must_have_task "bootstrap:create_deploy_user"
   end

   it "has a upload authorized keys for deploy user task" do
     recipe.must_have_task "bootstrap:upload_deploy_authorized_keys"
   end

   it "has a task for adding rvm group to sudoers" do
      recipe.must_have_task "bootstrap:add_rvm_to_sudoers"
   end

   it "has one for uploading the deploy user's ssh key" do
     recipe.must_have_task "bootstrap:upload_deploy_key"
   end

   it "has a task for installing rvm dependencies" do
     recipe.must_have_task "bootstrap:install_rvm_dependencies"
   end

   it "has a task for installing any other specified packages" do
     recipe.must_have_task "bootstrap:install_specified_packages"
   end
  end

  describe "default variables" do

    it "bootstrap user" do
      recipe.fetch(:bootstrap_user).must_equal 'prompt'
    end

    it "bootstrap user password" do
      recipe.fetch(:bootstrap_password).must_equal 'prompt'
    end

    it "deploy user" do
      recipe.fetch(:deploy_user).must_equal 'deploy'
    end

    it "packages" do
      recipe.fetch(:packages).must_be_empty
    end
  end

  describe "variables set" do
    before do
      recipe.set(:known_hosts, "baz")
    end

    it "user gets bootstrap_user" do
      recipe.fetch(:user).must_equal recipe.fetch(:bootstrap_user)
    end

    it "password gets bootstrap_password" do
      recipe.fetch(:password).must_equal recipe.fetch(:bootstrap_user)
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
