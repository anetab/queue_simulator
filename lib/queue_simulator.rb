module QueueSimulator
  extend self

  @@interrupt = false

  def interrupt
    @@interrupt = true
  end

  def interrupted?
    @@interrupt
  end
end

require 'queue_simulator/generator'
require 'queue_simulator/processor'
