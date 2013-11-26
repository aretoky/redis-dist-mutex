# -*- coding:utf-8 -*-
require './lib/redis-dist-mutex.rb'

def redis
  Redis.new db: 15
end

def create_thread(i, mutex)
  Thread.new do
    mutex.synchronize do
      redis.lpush('spec_mutex', Time.now.to_f)
      sleep rand
    end
  end
end

p Redis.constants

describe Redis::DistMutex do
  context 'no expire' do
    before(:each) { @mutex = Redis::DistMutex.new(:foo) }
    after(:each) { @mutex.unlock if @mutex.owned? }

    context 'locked?' do
      it { expect(@mutex.locked?).to be_false }
    end

    describe 'locked? after lock' do
      before do
        @mutex.lock
        @result = @mutex.locked?
      end
      it { expect(@result).to be_true }
    end

    describe 'synchronize' do
      before { @result = @mutex.synchronize { @mutex.unlock; :foo } }
      it { expect(@result).to eq :foo }
    end

    describe 'try_lock' do
      it { expect(@mutex.try_lock).to be_true }
    end

    describe 'try_lock after lock' do
      before { @mutex.lock }
      it { expect(@mutex.try_lock).to be_false }
    end
  end

  context 'with expire' do
    before(:each) { @mutex = Redis::DistMutex.new(:foo, expire: 0.5) }
    after(:each) { @mutex.unlock if @mutex.owned? }

    context 'before lock' do
      before { @mutex.lock }
      describe 'locked?' do
        it { expect(@mutex.locked?).to be_true }
      end
    end

    context 'after expired' do
      before do
        @mutex.lock
        sleep 0.6
      end
      describe 'locked?' do
        it { expect(@mutex.locked?).to be_false }
      end
    end

    context 'try to acquire lock by 5 threads' do
      before do
        redis.del('spec_mutex')
        5.times.map { |i| create_thread i, @mutex }.each(&:join)
      end

      describe 'redis.llen' do
        it { expect(redis.llen('spec_mutex')).to eq 5 }
      end

      describe 'timediff < 0.5' do
        before do
          diffs = []
          redis.lrange('spec_mutex', 0, -1).map(&:to_f).each_slice(2) do |vs|
            diffs << (vs[0] - vs[1]).abs if vs.length == 2
          end
          @rejects = diffs.select { |v| v < 0.5 }
        end
        describe 'rejects.length' do
          it { expect(@rejects.length).to be_zero }
        end
      end
    end
  end
end
