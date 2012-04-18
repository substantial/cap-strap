Capistrano::Configuration.instance.load do
  namespace :users do

    task :default do end

    set(:remove_users) { Capistrano::CLI.ui.ask("List users for removal: ") }

    desc "Removes users specified by -s remove_users=<users>. Use comma for multiple users.
          If no parameters are specified, it will prompt"
    task :remove do
      users = remove_users.split(%r{\,|\ })
      users.delete_if{|x| x ==''}
      puts users.inspect
      users.each do |user|
        if user_exists?(user)
          puts "***** Removing User: #{user}"
          sudo "userdel -r #{user}"
        else
          puts "***** Can't Remove User: #{user}, doesn't exist"
        end
      end
    end
  end

  def user_exists?(user)
    user_test = "if id #{user} > /dev/null 2>&1; then echo 'true'; else echo 'false'; fi"
    return capture(user_test).include?("true")
  end
end
