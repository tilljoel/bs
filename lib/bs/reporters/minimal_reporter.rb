# encoding: utf-8

module BS::Reporters
  class MinimalReporter < BaseReporter
    def report(commits)
      if commits.valid?
        commits.each { |commit| report_commit(commit) }
      else
        puts 'request error'
      end
    end

    def report_settings(config)
    end

    def report_commit(commit)
      non_pending = commit.status_list.select do |status|
        status.state != 'pending'
      end
      if non_pending.count > 0
        non_pending.each { |status| puts status.state }
      else
        if commit.status_list == []
          puts 'no status set'
          return
        end
        commit.status_list.each { |status| puts status.state }
      end
    end
  end
end
