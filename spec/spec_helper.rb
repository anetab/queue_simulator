$LOAD_PATH << (File.dirname(__FILE__) + '../lib')

require 'simplecov'
SimpleCov.start

require 'bundler'
Bundler.require :test
