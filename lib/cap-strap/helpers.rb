def _cset(name, *args, &block)
  unless exists?(name)
    set(name, *args, &block)
  end
end

def add_user_to_group(user, group)
  sudo "usermod -a -G #{group} #{user}"
end

def install_packages(packages)
  sudo "apt-get update"
  packages.each do |pkg|
    sudo "apt-get -y install #{package}"
  end
end

def create_user(user, primary_group, other_groups)
  sudo "useradd -g #{primary_group} -G #{other_groups} -s /bin/bash -d /home/#{user} -m #{user}"
end

def known_hosts
  <<-TEXT
github.com,207.97.227.239 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
  TEXT
end

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
