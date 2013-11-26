require "bundler/gem_tasks"

Bundler::GemHelper.install_tasks

task :test => [:spec]

require 'rspec'
require 'rspec/core/rake_task'

desc 'Run all RSpec Tests'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*.rb'
  spec.rspec_opts = ['-cfs']
end
