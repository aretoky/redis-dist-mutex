require "bundler/gem_tasks"

Bundler::GemHelper.install_tasks

require 'rspec'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')
task :test => [:spec]

desc 'Run all RSpec Tests'
RSpec::Core::RakeTask.new(:spec) do |spec|
  require 'redis'
  Redis.new(db: 15).flushdb
  spec.pattern = 'spec/**/*.rb'
  spec.rspec_opts = ['-cfs']
end
