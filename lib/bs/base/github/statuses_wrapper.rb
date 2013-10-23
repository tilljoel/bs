# encoding: utf-8
require 'github_api'
require 'forwardable'
require_relative 'commits_wrapper'
require_relative '../status_list'

module BS
  module Base
    module Github
      class StatusesWrapper
        extend Forwardable
        attr_reader :repo
        def_delegator :@repo, :repo_api, :repo_api

        def initialize(repo)
          @repo = repo
        end

        def status_list(sha)
          response = statuses(sha)
          StatusList.build_from_response(response.body)
        rescue ::Github::Error::ServiceError,
               ::Github::Error::ClientError,
               Faraday::Error::ClientError => e
          StatusList.build_with_error(error_message: e.message)
        end

        def add_statuses_to_commits(commits)
          commits.each do |commit|
            commit.status_list = status_list(commit.sha)
          end
        end

        private

        def statuses(sha)
          repo_api.statuses.list(repo_api.user, repo_api.repo, sha)
        end
      end
    end
  end
end
