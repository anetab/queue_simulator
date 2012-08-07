require 'spec_helper'
require 'queue_simulator'

module QueueSimulator
  describe Generator do
    let(:queue_name){"queue1"}
    let(:generator){QueueSimulator::Generator.new(queue_name)}

    before :each do
      QueueSimulator.start
    end

    it 'generates an array with jobs to add to the queue' do
      QueueSimulator::Generator::jobs_to_add(0,5).should eq [1, 2, 3, 4, 5]
    end

    it 'it adds the new jobs to the queue ' do
      redis = Redis.new()
      redis.flushdb
      generator.add_jobs_to_queue("test_queue", [1,2,3,7,9])
      redis.lrange("test_queue", 0, -1).should eq ["9","7","3","2","1"]
    end

    it 'adds jobs to the queue when perform is called' do
      generator.should_receive(:add_jobs_to_queue).at_least(1).times
      generator.perform
      sleep(3)
    end
  end
end
