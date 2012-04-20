require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

desc "Test cap-strap on a local virtual machine, courtesy of vagrant."
task :vagrant_test => ["vagrant_test:default"]

namespace :vagrant_test do

  task :default => [:up, :test]

  task :test do
    puts "Running cap bootstrap"
    %x[bundle exec cap bootstrap]
  end

  task :restart => [:down, :up, :test]

  task :down do
    puts "Forcing vagrant shutdown"
    %x[bundle exec vagrant destroy --force]
  end

  task :up do
    puts "WARNING: This will take a while..."
    puts "Starting up vagrant"
    %x[bundle exec vagrant up]
    puts "Vagrant is up."
  end
end

Rspec::Core::RakeTask.new do |t|
  t.pattern = "./spec/*_spec.rb"
end
