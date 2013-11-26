require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'redis-dist-mutex'

RSpec.configure do |spec|
  Redis::DistMutex.redis = Redis.new db: 15
end
