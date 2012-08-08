require 'redis'

module QueueSimulator
  class Generator
    MAX_JOB_NUMBER = 9
    MAX_SLEEP_TIME = 6

    attr_reader :job_thread

    def initialize(queue_name)
      @queue_name = queue_name
      @redis = Redis.new()
      @current_number_of_jobs = 0
    end

    def self.jobs_to_add(i, number)
      ((i + 1)..(i + number)).to_a
    end

    def add_jobs_to_queue(jobs)
      @redis.lpush(@queue_name, jobs)
    end

    def show_jobs_in_queue
      puts @redis.lrange(@queue_name, 0, -1)
    end

    def perform
      @redis.flushdb

      @job_thread = Thread.new do
        current_number_of_jobs = 0

        until QueueSimulator.stopped? do
          number_of_jobs_to_add = (1..MAX_JOB_NUMBER).to_a.sample
          jobs = QueueSimulator::Generator.jobs_to_add(current_number_of_jobs, number_of_jobs_to_add)

          puts "jobs to add #{jobs}"

          add_jobs_to_queue(jobs)
          current_number_of_jobs += number_of_jobs_to_add
          show_jobs_in_queue

          sleep((0..MAX_SLEEP_TIME).to_a.sample)
        end
      end
    end
  end
end
