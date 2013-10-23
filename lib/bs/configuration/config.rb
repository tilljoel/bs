# encoding: utf-8
require_relative 'init_config'
require_relative 'finalize_config'
require_relative 'graceful_exit'
require_relative 'log_handler'

module BS::Configuration
  class Config
    def initialize
      InitConfig.new
      FinalizeConfig.new
      LogHandler.new(Settings.log_level)
      # GracefulExit.enable
    end
  end
end
