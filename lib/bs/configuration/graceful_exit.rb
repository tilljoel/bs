# encoding: utf-8
require 'singleton'

module BS::Configuration
  class GracefulExit
    include Singleton

    attr_accessor :breaker

    def initialize
      self.breaker = false
    end

    def self.enable
      trap('INT') do
        yield if block_given?
        logger.info 'Caught Ctrl-C, waiting to exit'
        instance.breaker = true
      end
    end

    def self.check(message = 'Controlled exit after Ctrl-C')
      if instance.breaker
        yield if block_given?
        logger.info message
        puts message
        exit
      end
    end
  end
end
