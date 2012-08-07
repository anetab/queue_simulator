require 'spec_helper'
require 'queue_simulator'

describe QueueSimulator do
  let(:queue_name) {"queue1"}
  let(:generator){QueueSimulator::Generator.new(queue_name)}

  before :each do
    generator.perform
    QueueSimulator::Processor.perform
    sleep(10)
  end

  it 'stops the program when interrupt is true' do
    QueueSimulator.stop
    sleep(QueueSimulator::Generator::MAX_SLEEP_TIME+1)
    generator.job_thread.alive?.should be false
  end
end
