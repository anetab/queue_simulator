require 'spec_helper'
require 'queue_simulator/generator'

module QueueSimulator
  describe Generator do

    it 'randomly chooses a number of jobs to add' do
      number = QueueSimulator::Generator.job_number
      number.should be <= QueueSimulator::Generator::MAX_JOB_NUMBER
    end

    it 'generates an array with jobs to add to the queue' do
      QueueSimulator::Generator::jobs_to_add(0,5).should eq [1, 2, 3, 4, 5]
    end

    it 'it adds the new jobs to the queue ' do
      redis = Redis.new()
      redis.flushdb
      QueueSimulator::Generator.add_jobs_to_queue("test_queue", [1,2,3,7,9])
      redis.lrange("test_queue", 0, -1).should eq ["9","7","3","2","1"]
    end
  end
end
