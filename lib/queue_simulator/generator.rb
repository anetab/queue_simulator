require 'redis'
module QueueSimulator

  extend self

  @@interrupt = false

  def interrupt
    @@interrupt = true
  end

  def interrupted?
    @@interrupt
  end

  module Generator
    extend self

    MAX_JOB_NUMBER = 9
    MAX_SLEEP_TIME = 6

    @queue_key = 'queue1'
    @random = Random.new()
    @job_thread = nil

    def job_thread
      @job_thread
    end

    def join_thread
      job_thread.join
    end

    def job_number
      1 + @random.rand(MAX_JOB_NUMBER)
    end

    def jobs_to_add(i, number)
      Array((i + 1)..(i + number))
    end

    def add_jobs_to_queue(queue, jobs)
      @redis.lpush(queue, jobs)
    end

    def show_jobs_in_queue(queue)
      puts @redis.lrange(queue, 0, -1)
    end

    def update(old_value, increment)
      old_value += increment
    end

    def redis_cleanup
      @redis.flushdb
    end

    def perform
      trap("INT") { QueueSimulator.interrupt }
      @redis = Redis.new()
      redis_cleanup

      @job_thread = Thread.new do
        current_number_of_jobs = 0
        until QueueSimulator.interrupted? do
          number_of_added_jobs = job_number
          jobs = jobs_to_add(current_number_of_jobs, number_of_added_jobs)
          puts "jobs to add #{jobs}"
          add_jobs_to_queue(@queue_key, jobs)
          current_number_of_jobs = update(current_number_of_jobs, number_of_added_jobs)
          show_jobs_in_queue(@queue_key)
          sleep(@random.rand(MAX_SLEEP_TIME))
        end
      end
    end
  end
end
