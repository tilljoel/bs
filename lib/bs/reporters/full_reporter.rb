# encoding: utf-8
require 'command_line_reporter'

module BS::Reporters
  class FullReporter < BaseReporter
    def report(commits)

      unless commits.valid?
        ErrorReporter.new(commits).run
        return
      end

      StatusReporter.new(commits).run
    end

    def report_settings(config)
      SettingsReporter.new(config).run
    end

    private

    class StatusReporter
      include CommandLineReporter

      attr_reader :commits

      def initialize(commits)
        @commits = commits
        self.formatter = 'nested'
        formatter.complete_string = 'done'
      end

      def run
        puts "\nfound #{commits.length} commits:"
        commits.each do |commit|
          print_commit_tables(commit)
        end
      end

      private

      def print_commit_tables(commit)
        status_list = commit.status_list

        vertical_spacing 1

        table(border: true) do
          print_commit_info(commit)
        end

        status_list.each do |status|
          table(border: false) do
            print_status_info(status)
            print_status_urls(status)
            print_status_dates(status)
          end
          vertical_spacing 1
        end
        vertical_spacing 2
      end

      def print_commit_info(commit)
        return unless commit
        row do
          commit_title = "#{commit.sha}  ---  by #{commit.committer.login}"
          commit_title += ' (no ci status set)' if commit.status_list == []
          column(commit_title, width: 100, padding: 2)
        end
      end

      def print_status_info(status)
        row do
          column('state:', width: 18, padding: 0, align: 'right')
          column(status.state, width: 100, padding: 0)
        end
        row do
          column('description:', align: 'right')
          column(status.description)
        end
      end

      def print_status_urls(status)
        row do
          column('build url:', align: 'right')
          column(status.target_url)
        end
      end

      def print_status_dates(status)
        row do
          column('created:', align: 'right')
          column(status.created_at.to_s)
        end
        row do
          column('updated:', align: 'right')
          column(status.updated_at.to_s)
        end
      end
    end

    class ErrorReporter
      include CommandLineReporter

      attr_reader :commits

      def initialize(commits)
        @commits = commits
        self.formatter = 'nested'
        formatter.complete_string = 'done'
      end

      def run
        table(border: true) do
          print_error
        end
      end

      private

      def print_error
        row do
          column('error', width: 18, padding: 0, align: 'right')
          column(commits.error_message, width: 100, padding: 0)
        end
      end
    end

    class SettingsReporter
      include CommandLineReporter

      attr_accessor :config
      def initialize(config)
        @config = config
        self.formatter = 'nested'
        formatter.complete_string = 'done'
      end

      def run
        print_header_info

        puts 'using these settings:'
        puts ''
        table(border: false) do
          print_settings_repo
          print_settings_output
          print_settings_github
        end
      end

      private

      def print_header_info
        header(title: "running #{BS::NAME_AND_VERSION}",
               width: 115,
               align: 'left',
               bold: true,
               timestamp: false)
      end

      def print_settings_repo
        row do
          column('owner:', width: 18, padding: 0, align: 'right')
          column(config.owner, width: 100, padding: 0)
        end
        row do
          column('repo:')
          column(config.repo)
        end
        row do
          column('ref:')
          column(config.ref)
        end
      end

      def print_settings_output
        row do
          column('verbose:')
          column(config.verbose)
        end
        row do
          column('reporter:')
          column(config.reporter)
        end
        row do
          column('log_level:')
          column(config.log_level)
        end
      end

      def print_settings_github
        row do
          column('github_user:')
          column(config.github_user)
        end
        row do
          column('github_password:')
          len = config.github_password ?  config.github_password.length : 0
          column("#{'*' * len}")
        end
      end
    end
  end
end
