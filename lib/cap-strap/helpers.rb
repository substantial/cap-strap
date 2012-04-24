def _cset(name, *args, &block)
  unless exists?(name)
    set(name, *args, &block)
  end
end

def add_user_to_group(user, group)
  sudo "usermod -a -G #{group} #{user}"
end

def install_packages(packages)
  unless packages.empty?
    sudo "apt-get update"
    packages.each do |pkg|
      sudo "apt-get -y install #{pkg}"
    end
  end
end

def create_user(user)
  unless user_exists?(user)
    sudo "useradd -s /bin/bash -d /home/#{user} -m #{user}"
  end
end

def add_group_to_sudoers(group)
  unless group_has_sudo?(group)
    puts "********* Adding #{group} to sudoers"
    sudo "cp /etc/sudoers /etc/sudoers.bak"
    sudo "chmod a+w /etc/sudoers.bak"
    sudo "echo %rvm ALL=NOPASSWD:ALL >> /etc/sudoers.bak"
    sudo "chmod a-w /etc/sudoers.bak"
    sudo "mv /etc/sudoers.bak /etc/sudoers"
  end
end

def group_has_sudo?(group)
  sudoer_test = "sudo bash -c \"if grep -Fxq '%#{group} ALL=NOPASSWD:ALL' /etc/sudoers; then echo 'true'; else echo 'false'; fi\""
  return capture(sudoer_test).include?("true")
end

def user_exists?(user)
  user_test = "if id #{user} > /dev/null 2>&1; then echo 'true'; else echo 'false'; fi"
  return capture(user_test).include?("true")
end

def default_known_hosts
<<TEXT
github.com,207.97.227.239 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
TEXT
end

def ruby_installed?(ruby)
  ruby_test = "source /etc/profile.d/rvm.sh && if rvm list | grep -q '#{ruby} '; then echo 'true'; else echo 'false'; fi"
  return capture(rvm_wrapper(ruby_test)).include?("true")
end

def install_ruby(ruby, patch = nil)
  unless ruby_installed?(ruby)
    command = "rvm install #{ruby}"
    command << " --patch #{patch}" if patch
    sudo rvm_wrapper(command)
  end
end

def install_global_gem(ruby, gem)
  sudo rvm_wrapper("rvm use #{ruby}@global --create && gem install #{gem} --no-rdoc --no-ri")
end

def rvm_wrapper(command)
  "bash -c \". /etc/profile.d/rvm.sh && #{command}\""
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
