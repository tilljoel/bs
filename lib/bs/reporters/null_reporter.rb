# encoding: utf-8

module BS::Reporters
  class NoneReporter < BaseReporter
    def report(commit_status)
      logger.debug 'skip: report status'
    end

    def report_settings(config)
      logger.debug 'skip: report settings'
    end
  end
end
