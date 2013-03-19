require "bundler/gem_tasks"

# Rspec tasks
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# Version tasks
require 'rake/version_task'
Rake::VersionTask.new

# include Rake::DSL if defined?(Rake::DSL)

RVM_PREFIX = "rvm 1.9.3-p327,2.0.0 do"


namespace :spec do
  desc "Run on three Rubies"
  task :platforms do
    exit $?.exitstatus unless system "#{RVM_PREFIX} bundle install"
    exit $?.exitstatus unless system "#{RVM_PREFIX} bundle exec rake spec"
  end
end

task default: 'spec:platforms'

desc 'Push everywhere!'
task :publish do
  system %{git push github}
  system %{git push github --tags}
  system %{git push gitcafe}
  system %{git push gitcafe --tags}
end
