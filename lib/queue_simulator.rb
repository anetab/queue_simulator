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
  end
end

require 'queue_simulator/generator'
require 'queue_simulator/processor'
