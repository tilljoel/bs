# encoding: utf-8
require_relative 'base_reporter'

module BS::Reporters

  def self.require_all_reporters
    reporters_dir = '.'
    files = Dir[File.dirname(__FILE__) + "/#{reporters_dir}/*_reporter.rb"]
    files.each do |file|
      reporter = File.basename(file, File.extname(file))
      require_relative "#{reporters_dir}/#{reporter}"
    end
  end

  require_all_reporters

  class ReportHandler
    attr_accessor :reporters, :reporter_name

    def reporter(reporter_name)
      new_reporter_from_config_name(reporter_name)
    end

    def reporters
      @reporters ||= BaseReporter.descendants
    end

    private

    def new_reporter_from_config_name(config_name)
      reporter = reporters.find { |rep| rep.config_name == config_name }
      reporter = DefaultReporter unless reporter
      reporter.new
    end
  end
end
