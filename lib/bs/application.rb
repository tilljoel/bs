# encoding: utf-8
require_relative 'base/repo'
require_relative 'configuration/config'
require_relative 'reporters/report_handler'

module BS
  class Application

    attr_writer :config

    def initialize
      Configuration::Config.new
    end

    def run
      logger.debug "Run with config #{config}"

      print_settings
      fetch_commits_with_statuses
      print_statuses
      exit_with_correct_exit_code
    end

    private

    def print_settings
      reporter.report_settings(config)
    end

    def print_statuses
      reporter.report(commits)
    end

    def reporter
      @reporter ||= Reporters::ReportHandler.new.reporter(config.reporter)
    end

    def commits
      @commits ||= fetch_commits_with_statuses
    end

    def fetch_commits_with_statuses
      @commits ||= repo.commit_list(config.ref, config.limit)
    end

    def repo
      Base::Repo.new(config)
    end

    def config
      @config ||= Settings
    end

    def exit_with_correct_exit_code
      if commits.valid?
        exit 0
      else
        logger.info 'invalid response for commit'
        exit 1
      end
    end
  end
end
