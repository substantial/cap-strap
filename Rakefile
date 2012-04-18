require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

Rspec::Core::RakeTask.new do |t|
  t.pattern = "./spec/*_spec.rb"
end
