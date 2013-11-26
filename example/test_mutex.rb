require 'redis'
require 'redis-dist-mutex'

class TestMutex
  def initialize
    @redis = Redis.new
    Redis::DistMutex.redis = @redis
    @mutex = Redis::DistMutex.new :test_app, expire: 1, autorelease: false
  end

  def create_thread(id)
    Thread.new do
      now = -> { sprintf('%.1f', Time.now.to_f) }
      @redis.lpush('hoge_test:start', "#{id}:#{now.call}")
      @mutex.synchronize { @redis.lpush('hoge_test:end', "#{id}:#{now.call}"); sleep 2 + rand }
    end
  end

  def start
    puts '-' * 40
    @redis.del('hoge_test:start')
    @redis.del('hoge_test:end')
    5.times.map { |id| create_thread(id) }.each(&:join)
    puts "Start: #{@redis.lrange('hoge_test:start', 0, -1)}"
    puts "End  : #{@redis.lrange('hoge_test:end', 0, -1)}"
  end
end

if $0 == __FILE__
  test = TestMutex.new
  3.times.each { |i| test.start }
end
