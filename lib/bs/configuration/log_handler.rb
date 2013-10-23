# encoding: utf-8
require 'logging'

include Logging.globally
module BS::Configuration
  class LogHandler

    LOG_LEVELS = [:DEBUG, :INFO, :WARN, :ERROR, :FATAL]

    attr_accessor :level

    def initialize(user_log_level)
      level = user_log_level.upcase.to_sym
      level = :INFO unless LOG_LEVELS.include?(level)

      set_a_bright_color_scheme
      add_an_stdout_appender

      Logging.logger.root.appenders = Logging.appenders.stdout
      Logging.logger.root.level = level
    end

    def default_log_level
      :INFO
    end

    private

    def add_an_stdout_appender
      layout = Logging.layouts.pattern(pattern:  '[%d] %-5l %c: %m\n',
                                       color_scheme:  'bright')
      Logging.appenders.stdout('stdout', layout:  layout)
    end

    def set_a_bright_color_scheme
      Logging.color_scheme('bright',
                           levels:  {
                             info:  :green,
                             warn:  :yellow,
                             error:  :red,
                             fatal:  [:white, :on_red]
                           },
                           date:  :blue,
                           logger:  :cyan,
                           message:  :magenta)
    end
  end
end
