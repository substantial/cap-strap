# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "cap-strap"
  s.version     = "0.0.3"
  s.authors     = ["Shaun Dern"]
  s.email       = ["shaun@substantial.com"]
  s.homepage    = "http://github.com/substantial/cap-strap"
  s.summary     = %q{Bootstrap a new machine. Use with Capistrano to fully automate your provisioning.}
  s.description = %q{Bootstrap a machine. Create a deploy user, upload authorized keys and deploy key. Uses RVM to install desired rubies, with patch support.}

  s.rubyforge_project = "cap-strap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "capistrano", '>= 2.0.0'
  s.add_development_dependency "capistrano-spec","~> 0.1.0"
  s.add_development_dependency "rspec", "~> 2.9.0"
  s.add_development_dependency "guard-rspec", "~> 0.7.0"
  s.add_development_dependency "vagrant", "~> 1.0.2"


  s.add_runtime_dependency "capistrano", ">= 2.0.0"
end
