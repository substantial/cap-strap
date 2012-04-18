Capistrano::Configuration.instance.load do
  namespace :rvm do
    task :default do
      rvm.install_system_wide_rvm
      rvm.add_gemrc
      rvm.add_user_to_rvm_group
      rvm.install_rubies
      rvm.set_default_ruby
      rvm.create_default_gemset
    end

    task :add_user_to_rvm_group do
      add_user_to_group(user, "rvm")
    end

    task :install_system_wide_rvm do
      command = "curl -L get.rvm.io | "
      command << "sudo bash -s stable"
      run command, :shell => :bash
    end

    task :install_rubies do
      rubies.each do |rubie|
        if rubie.is_a?(Hash)
          ruby = rubie.fetch(:version)
          ruby_patch = rubie.fetch(:patch)
        else
          ruby = rubie
          ruby_patch = nil
        end

        install_ruby(ruby, ruby_patch)
        install_global_gem(ruby, "bundler")
      end
    end

    task :create_default_gemset do
      sudo rvm_wrapper("rvm use #{default_ruby}@#{gemset} --create")
    end

    task :set_default_ruby do
      sudo rvm_wrapper("rvm use #{default_ruby} --default")
    end

    task :add_gemrc do
      gemrc = <<-TEXT
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

      put gemrc, "gemrc"
      sudo "mv ~/gemrc /etc/"
    end
  end

  def add_user_to_group(user, group)
    sudo "usermod -a -G #{group} #{user}"
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
end
