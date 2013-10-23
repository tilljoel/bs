# encoding: utf-8
require 'github_api'
require_relative 'github/statuses_wrapper'
require_relative 'github/commits_wrapper'

module BS
  module Base
    class Repo

      attr_accessor :github_user, :github_password, :owner, :repo, :repo_api

      def initialize(config = nil)
        if config
          @github_password = config.github_password
          @github_user     = config.github_user
          @owner           = config.owner
          @repo            = config.repo
        end
      end

      def repo_api
        @repo_api ||= init_repo_api
      end

      def commit_list(ref, limit)
        commit_list = Github::CommitsWrapper.new(self).commit_list(ref, limit)

        return commit_list if commit_list.invalid?
        statuses_wrapper = Github::StatusesWrapper.new(self)
        commit_list = statuses_wrapper.add_statuses_to_commits(commit_list)
        commit_list
      end

      def status_list(ref)
        StatusWrapper.new(self).status_list(ref)
      end

      private

      def init_repo_api
        if github_user && github_password
          ::Github::Repos.new(login: github_user, password: github_password,
                              user: owner, repo: repo)
        else
          ::Github::Repos.new(user: owner, repo: repo)
        end
      end
    end
  end
end
