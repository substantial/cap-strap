def _cset(name, *args, &block)
  unless exists?(name)
    set(name, *args, &block)
  end
end

def add_user_to_group(user, group)
  sudo "usermod -a -G #{group} #{user}"
end


def remove_user(user)
  if user_exists?(user)
    puts "***** Removing User: #{user}"
    sudo "userdel -r #{user}"
  else
    puts "***** Can't Remove User: #{user}, doesn't exist"
  end
end

def user_exists?(user)
  user_test = "if id #{user} > /dev/null 2>&1; then echo 'true'; else echo 'false'; fi"
  return capture(user_test).include?("true")
end

def install_packages(packages)
  sudo "apt-get update"
  packages.each do |pkg|
    apt_install pkg
  end
end

def apt_install(package)
  puts "\n"
  puts "Installing package: #{package}"
  puts "========================================================="
  sudo "apt-get -y install #{package}"
end

def authorized_keys
end

def known_hosts
  <<-TEXT
github.com,207.97.227.239 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
  TEXT
  end
