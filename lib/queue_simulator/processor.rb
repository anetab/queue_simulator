require 'redis'

module QueueSimulator

  module Processor
    extend self

    MAX_WORKER_NUMBER = 3
    MAX_SLEEP_TIME = 3

    attr_reader :worker_threads

    @queue_key = 'queue1'
    @random = Random.new()
    @worker_threads = []

    def number_of_workers
      if !(@number_of_workers)
        @number_of_workers = 1 + @random.rand(MAX_WORKER_NUMBER)
      else
        @number_of_workers
      end
    end

    def join_threads
      worker_threads.map(&:join)
    end

    def perform
      trap("INT") { QueueSimulator.stop}
      @redis = Redis.new()
      number_of_workers.times do
        @worker_threads << Thread.new do
          until QueueSimulator.stopped? do
            puts "processed job #{@redis.rpop(@queue_key)}"
            sleep(@random.rand(MAX_SLEEP_TIME))
          end
        end
      end
    end
  end
end
