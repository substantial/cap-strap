Capistrano::Configuration.instance.load do
  @packages = %w( build-essential openssl libreadline6 libreadline6-dev
  curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev
  libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf
  libc6-dev ncurses-dev automake libtool bison subversion )

  namespace :deploy do
    desc "bootstraps a fresh box. Specify root user in commandline using -s user=<root>"
    task :bootstrap do
      install_packages
      rvm.default
      deploy.create_deploy_user
      deploy.upload_deploy_authorized_keys
      deploy.add_known_hosts
      deploy.add_rvm_to_sudoers
    end

     task :set_ownership do
       sudo "chown -R #{user}:#{group} #{deploy_to}"
     end

     task :create_deploy_user do
       sudo "useradd -g rvm -G admin -s /bin/bash -d /home/deploy -m deploy"
     end

     task :upload_deploy_authorized_keys do
       sudo 'mkdir -p /home/deploy/.ssh'
       sudo 'chmod 0700 /home/deploy/.ssh'
       put(authorized_keys, "authorized_keys", :mode => "0600")
       sudo "mv ~/authorized_keys /home/deploy/.ssh/"
       sudo 'chown -R deploy:rvm /home/deploy/.ssh'
     end

     task :add_known_hosts do
       put(known_hosts, "known_hosts", :mode => "0644")
       sudo "mv ~/known_hosts /home/deploy/.ssh/known_hosts"
       sudo 'chown -R deploy:rvm /home/deploy/.ssh'
     end

     task :add_rvm_to_sudoers do
        sudo "echo %rvm ALL=NOPASSWD:ALL >> /etc/sudoers"
     end
  end

  def install_packages
    sudo "apt-get update"
    @packages.each do |pkg|
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
end
