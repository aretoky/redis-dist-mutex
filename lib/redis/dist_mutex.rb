# -*- coding:utf-8 -*-
class Redis
  class DistMutex

    def self.redis=(server)
      @@redis = server
    end

    def self.redis
      @@redis
    end

    attr_writer :expire, :autorelease

    def initialize(name, **options)
      @name = name
      @expire = options[:expire]
      @autorelease = options[:autorelease].nil? ? true : options[:autorelease]
      @retry_max = options[:retry_max]
      @interval = options[:interval] || 0.5
      @allow_self_wait = options[:allow_self_wait] || false
      @raise_lock_fail = options[:raise_lock_fail] || false
    end

    def lock
      raise ThreadError.new 'deadlock; recursive locking' if @allow_self_wait == false && owned?
      i = 0
      loop do
        if try_lock
          set_expire if @expire
          break
        end
        i += 1
        if @retry_max.nil? == false && i > @retry_max
          raise StandardError, "Failed to lock : #{key}" if @raise_lock_fail
          return false
        end
        Kernel.sleep @interval
      end
      self
    end

    def locked?
      locked_by.nil? == false
    end

    def owned?
      locked_by == identity
    end

    def sleep(timeout = nil)
      raise ThreadError.new 'Attempt to unlock a mutex which is locked by another thread' unless owned?
      Kernel.sleep timeout
      unlock
    end

    def synchronize(&block)
      begin
        lock
        block.call
      ensure
        unlock if @autorelease && owned?
      end
    end

    def try_lock
      @@redis.setnx(key, identity)
    end

    def unlock
      unless owned?
        raise ThreadError.new 'Attempt to unlock a mutex which is locked by another thread'
      end
      if @@redis.del(key) == 0
        raise ThreadError.new 'Attempt to unlock a mutex which is not locked'
      end
      self
    end

    private

    def key
      "mutex:#{@name}"
    end

    def identity
      [Socket.gethostname, Process.pid, Thread.current.object_id].join('#')
    end

    def locked_by
      @@redis.get(key)
    end

    def set_expire
      if @expire < 1.0
        @@redis.pexpire(key, (@expire * 1000).to_i)
      else
        @@redis.expire(key, @expire)
      end
    end

  end
end
