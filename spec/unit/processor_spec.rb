require 'spec_helper'
require 'queue_simulator'

module QueueSimulator
  describe Processor do
    let(:queue_name){ "queue1" }
    let(:processor){ QueueSimulator::Processor.new(queue_name) }
    let(:redis){ Redis.new() }

    before :each do
      QueueSimulator.stop
      redis.flushdb
      QueueSimulator.start
    end

    it 'removes a job from the queue' do
      redis.lpush(queue_name, (1..10).to_a)
      expect { processor.remove_job }.to change { redis.llen(queue_name)}.by(-1)
    end

    it 'removes jobs from the queue when perform is called' do
      redis.lpush(queue_name, (1..10))
      processor.should_receive(:remove_job).at_least(1).times
      processor.perform
      sleep(3)
    end

    it 'stops processing jobs when QueueSimulator is stopped' do
      processor.perform
      sleep(1)
      QueueSimulator.stop
      sleep(2)
      processor.worker_threads.count.times do |i|
        processor.worker_threads[i].alive?.should be false
      end
    end

  end
end
