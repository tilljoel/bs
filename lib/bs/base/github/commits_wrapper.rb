# encoding: utf-8
require 'forwardable'
require 'github_api'
require_relative '../commit_list'

module BS
  module Base
    module Github
      class CommitsWrapper
        extend Forwardable
        attr_reader :repo
        def_delegator :@repo, :repo_api, :repo_api

        def initialize(repo)
          @repo = repo
        end

        def commit_list(ref, limit = 2)
          response = commits(ref)
          CommitList.build_from_response(ref: ref,
                                         owner: repo.owner,
                                         repo: repo.repo,
                                         response: response.body,
                                         limit: limit)
        rescue ::Github::Error::ServiceError,
               Faraday::Error::ClientError => e
          CommitList.build_with_error(ref: ref,
                                      owner: repo.owner,
                                      repo: repo.repo,
                                      error_message: e.message)
        end

        private

        def commits(ref)
          repo_api.commits.all(repo_api.user, repo_api.repo, sha: ref)
        end
      end
    end
  end
end
