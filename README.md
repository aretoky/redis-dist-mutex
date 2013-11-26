# Redis::DistMutex

Distributed mutex using Redis.

Compatible with ruby Mutex.
Enable to set expire to the lockfile. If set, act as like a setInterval in JavaScript.

## Installation

Add this line to your application's Gemfile:

    gem 'redis-dist-mutex', :git => 'https://github.com/vasilyjp/redis-dist-mutex.git'


## Usage

### setup

```ruby
Redis::DistMutex.redis = Redis.new
```

### synchoronize

```ruby
mutex = Redis::DistMutex.new :app_name
mutex.synchronize { puts "act with lock" }
```

### lock/unlock

```ruby
mutex = Redis::DistMutex.new :app_name
begin
  mutex.lock
 puts "act with lock"
ensure
  mutex.unlock
end
```

### Lock with expire (Set expire and autorelase)

```ruby
mutex = Redis::DistMutex.new :app_name, expire: 1, autorelease: false
mutex.synchronize { puts "unlock after 1 sec." }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
