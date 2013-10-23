# encoding: utf-8
module BS::Reporters
  class DefaultNoColorReporter < BaseReporter

    def report(commits)

      unless commits.valid?
        repo = repo_string(commits, commits.ref)
        report_error(commits, repo)
        return
      end

      commits.each do |commit|
        repo = repo_string(commits, commit.sha)
        report_commit(commit, repo)
      end
    end

    def report_settings(config)
      repo_and_ref = "#{config.owner}/#{config.repo}"\
                     " @ #{config.ref}"
      puts "#{BS::NAME_AND_VERSION}"
      puts ''
      puts "fetching status for #{repo_and_ref}"
      puts ''
    end

    private

    def repo_string(commits, ref)
      short_ref = shorten_if_sha(ref)
      "#{commits.owner}"\
      "/#{commits.repo}"\
      " @ #{short_ref}"
    end

    def report_error(commits, repo)
      puts "#{repo} - request error: #{commits.error_message}\n"
    end

    def report_commit(commit, repo)
      if commit.status_list == []
        print_state('no status set', repo)
        return
      end

      non_pending = commit.status_list.select do |status|
        status.state != 'pending'
      end

      if non_pending.count > 0
        non_pending.each { |status| print_state(status.state, repo) }
      else
        commit.status_list.each { |status| print_state(status.state, repo) }
      end
    end

    def print_state(state, repo)
      puts "#{repo} - #{state}\n"
    end
  end
end
