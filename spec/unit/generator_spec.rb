require 'spec_helper'
require 'queue_simulator/generator'

module QueueSimulator
  describe Generator do

    it 'randomly chooses a number of jobs to add' do
      number = QueueSimulator::Generator.job_number
      number.should be <= QueueSimulator::Generator::MAX_JOB_NUMBER
    end
  end
end
