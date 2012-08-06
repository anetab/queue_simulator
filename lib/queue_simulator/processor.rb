require 'redis'
module QueueSimulator

  module Processor
    extend self

    MAX_WORKER_NUMBER = 3
    MAX_SLEEP_TIME = 3

    @queue_key = 'queue1'
    @random = Random.new()
    @worker_threads = []

    def worker_threads
      @worker_threads
    end

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
      trap("INT") { QueueSimulator.interrupt }
      @redis = Redis.new()
        number_of_workers.times do
         @worker_threads << Thread.new do
            loop do
              exit if QueueSimulator.interrupted?
              puts "processed job #{@redis.rpop(@queue_key)}"
              sleep(@random.rand(MAX_SLEEP_TIME))
            end
        end
      end
    end
  end
end
