# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cap-strap/version"

Gem::Specification.new do |s|
  s.name        = "cap-strap"
  s.version     = CapStrap::VERSION
  s.authors     = ["Shaun Dern"]
  s.email       = ["shaun@substantial.com"]
  s.homepage    = ""
  s.summary     = %q{Bootstrap a new machine with cap-strap, a Capistrano extension}
  s.description = %q{Adds a deploy user and installs rvm and desired rubies.}

  s.rubyforge_project = "cap-strap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "capistrano", '>= 2.0.0'
  s.add_development_dependency "capistrano-spec"
  s.add_development_dependency "rspec"

  s.add_runtime_dependency "capistrano", ">= 2.0.0"
end
