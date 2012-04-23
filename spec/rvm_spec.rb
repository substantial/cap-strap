require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Capistrano::CapStrap::RVM do
  load_capistrano_recipe(Capistrano::CapStrap::RVM)

  describe "default variables" do
    let(:default_ruby) { "1.9.3-p125" }
    before do
      Capistrano::CLI.ui.stubs(:ask).returns('prompt')
    end

    it "has a prompts for a bootstrap user" do
      recipe.fetch(:user).must_equal "prompt"
    end

    it "has a default ruby" do
      recipe.fetch(:default_ruby).must_equal default_ruby
    end

    it "has a default gemset" do
      recipe.fetch(:gemset).must_equal "global"
    end

    it "has a rubie ruby set" do
      recipe.fetch(:rubies).length.must_equal 1
    end

    it "default ruby is in rubies" do
      recipe.fetch(:rubies).must_include default_ruby
    end

    it "has bundler in it's global gems" do
      recipe.fetch(:global_gems).must_include 'bundler'
    end
  end
end
