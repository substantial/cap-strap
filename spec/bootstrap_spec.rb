require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Capistrano::CapStrap::Bootstrap do
  load_capistrano_recipe(Capistrano::CapStrap::Bootstrap)

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

    it "packages is empty" do
      recipe.fetch(:packages).must_be_empty
    end
  end

  describe "variables set" do
    before do
      recipe.set(:user, "foo")
      recipe.set(:deploy_user, "bar")
      recipe.set(:known_hosts, "baz")
    end

    it "doesn't prompt for a bootstrap user" do
      recipe.fetch(:user).must_equal "foo"
    end

    it "doesn't prompt for a deploy user" do
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
