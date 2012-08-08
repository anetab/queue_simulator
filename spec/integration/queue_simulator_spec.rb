require 'spec_helper'
require 'queue_simulator'

describe QueueSimulator do
  let(:queue_name) {"queue1"}
  let(:generator){QueueSimulator::Generator.new(queue_name)}
  let(:processor){QueueSimulator::Processor.new(queue_name)}

  before :each do
    QueueSimulator.stop
    sleep(1)
    Redis.new().flushdb
    QueueSimulator.start
    generator.perform
    processor.perform
    sleep(1)
  end

  it 'has generator and processor threads while running' do
    generator.job_thread.alive?.should be true
    processor.worker_threads.count.times do |i|
      processor.worker_threads[i].alive?.should be true
    end

  end

  it 'stops the program when interrupt is true' do
    QueueSimulator.stop
    sleep(QueueSimulator::Generator::MAX_SLEEP_TIME+1)
    generator.job_thread.alive?.should be false
    processor.worker_threads.count.times do |i|
      processor.worker_threads[i].alive?.should be false
    end

  end
end
