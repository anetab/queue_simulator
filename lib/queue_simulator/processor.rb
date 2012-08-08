require 'redis'

module QueueSimulator

  class Processor

    MAX_WORKER_NUMBER = 3
    MAX_SLEEP_TIME = 3

    attr_reader :worker_threads

    def initialize(queue_name)
      @queue_name = queue_name
      @redis = Redis.new()
      @worker_threads = []
    end

    def join_threads
      worker_threads.map(&:join)
    end

    def remove_job
      @redis.rpop(@queue_name)
    end

    def perform
      trap("INT") { QueueSimulator.stop}
      @redis = Redis.new()
      number_of_workers = (1..MAX_WORKER_NUMBER).to_a.sample
      number_of_workers.times do
        @worker_threads << Thread.new do
          until QueueSimulator.stopped? do
            puts "processed job #{remove_job}"
            sleep((0..MAX_SLEEP_TIME).to_a.sample)
          end
        end
      end
    end
  end
end
