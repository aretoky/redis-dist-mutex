require 'redis'
require 'redis-dist-mutex'

Redis::DistMutex.redis = Redis.new
mutex = Redis::DistMutex.new(:test_app, expire: 1, auto_release: false)
mutex.synchronize { puts 'started'; sleep rand(5) }
