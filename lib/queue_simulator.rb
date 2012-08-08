module QueueSimulator
  extend self

  @@interrupt = false

  def stop
    @@interrupt = true
  end

  def stopped?
    @@interrupt
  end

  def start
    @@interrupt = false
    trap("INT") { QueueSimulator.stop}
  end
end

require 'queue_simulator/generator'
require 'queue_simulator/processor'
