require '../lib/queue_simulator/generator'
require '../lib/queue_simulator/processor'


QueueSimulator::Generator.perform
QueueSimulator::Processor.perform
QueueSimulator::Generator.join_thread
QueueSimulator::Processor.join_threads
