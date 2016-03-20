require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

Dir["#{File.dirname(__FILE__)}././app/**/*.rb"].each { |f| require(f) }

require "matrix"
require 'minitest/autorun'
