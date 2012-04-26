# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "cap-strap"
  s.version     = "0.0.9"
  s.authors     = ["Shaun Dern"]
  s.email       = ["shaun@substantial.com"]
  s.homepage    = "http://github.com/substantial/cap-strap"
  s.summary     = %q{Bootstrap a new machine. Use with Capistrano to fully automate your provisioning.}
  s.description = %q{Bootstrap a machine. Install packages, create a deploy user, upload authorized keys and deploy key. Uses RVM to install desired rubies, with patch support.}

  s.rubyforge_project = "cap-strap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake", "~> 0.9.2.2"
  s.add_development_dependency "minitest", "~> 2.12.1"
  s.add_development_dependency "minitest-capistrano", "~> 0.0.8"
  s.add_development_dependency "minitest-colorize", "~> 0.0.4"
  s.add_development_dependency "guard-minitest", "~> 0.5.0"
  s.add_development_dependency "mocha", "~> 0.11.3"
  s.add_development_dependency "vagrant", "~> 1.0.2"

  s.add_dependency "capistrano", ">= 2.0.0"
end
