require 'rspec'

describe 'generator' do

  it 'randomly chooses a number of jobs to add' do
    number = Generator.job_number
    number.should be < Generator::MAX_JOB_NUMBER
  end


end
