require 'spec_helper'
require 'queue_simulator'

describe QueueSimulator do

  before :each do
    QueueSimulator::Generator.perform
    QueueSimulator::Processor.perform
    sleep(10)
  end

  it 'stops the program when interrupt is true' do
    QueueSimulator.interrupt
    sleep(QueueSimulator::Generator::MAX_SLEEP_TIME+1)
    QueueSimulator::Generator.job_thread.alive?.should be false
  end
end
