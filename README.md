# Redis::DistMutex

Distributed mutex using Redis.
Conpatible with redis Mutex.
Enable to set expire to the lockfile. If set, act as like a setInterval in JavaScript.

## Installation

Add this line to your application's Gemfile:

    gem 'redis-dist-mutex'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis-dist-mutex

## Usage

### initialize

```ruby
Redis::DistMutex.redis = Redis.new
```

### synchoronize

```ruby
mutex = Redis::DistMutex.new :app_name
mutex.synchronize { puts "act with lock" }
```

### lock/unlock

```
mutex = Redis::DistMutex.new :app_name
begin
  mutex.lock
 puts "act with lock"
ensure
  mutex.unlock
end
```

### Set expire and autorelase

```
mutex = Redis::DistMutex.new :app_name, expire: 1, autorelease: false
mutex.synchronize { puts "unlock after 1 sec." }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
