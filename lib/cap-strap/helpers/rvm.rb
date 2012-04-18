def install_ruby(ruby, patch = nil)
  command = "rvm install #{ruby}"
  command << " --patch #{patch}" if patch
  sudo rvm_wrapper(command)
end

def install_global_gem(ruby, gem)
  sudo rvm_wrapper("rvm use #{ruby}@global --create && gem install #{gem} --no-rdoc --no-ri")
end

def rvm_wrapper(command)
  "bash -c '. /etc/profile.d/rvm.sh && #{command}'"
end

def gemrc
<<TEXT
---
:update_sources: true
:sources:
- http://gems.rubyforge.org/
- http://gems.github.com
:benchmark: false
:bulk_threshold: 1000
:backtrace: false
:verbose: true
gem: --no-ri --no-rdoc
TEXT
end
