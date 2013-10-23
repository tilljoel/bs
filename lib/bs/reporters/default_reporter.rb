# encoding: utf-8
require_relative 'default_no_color_reporter'
require 'cli-colorize'

module BS::Reporters
  class DefaultReporter < DefaultNoColorReporter
    include CLIColorize

    private

    # Override some methods and add color
    def repo_string(commits, ref)
      short_ref = shorten_if_sha(ref)
      "#{commits.owner.blue}"\
      "/#{commits.repo.blue}"\
      " @ #{short_ref.blue}"
    end

    def report_error(commits, repo)
      puts "#{repo} - request error: #{commits.error_message.red}\n"
    end

    def print_state(state, repo)
      col = color_for_state(state)
      puts "#{repo} - #{colorize(state, foreground: col)}\n"
    end

    def color_for_state(state)
      case state
      when 'success'       then :green
      when 'error'         then :red
      when 'pending'       then :yellow
      when 'no status set' then :yellow
      when 'failure'       then :red
      else :white
      end
    end
  end
end
