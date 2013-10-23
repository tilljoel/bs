# encoding: utf-8
require_relative 'github/commit_builder'
require_relative 'user'

module BS
  module Base
    class Commit

      attr_accessor :status_list
      attr_reader :sha
      attr_reader :author
      attr_reader :committer
      attr_reader :message
      attr_reader :url

      def self.build_from_response(response)
        builder = Github::CommitBuilder.new(response)
        new(
          sha: builder.sha,
          author: builder.author,
          committer: builder.commiter,
          message: builder.message,
          url: builder.url
        )
      end

      def initialize(attr)
        @sha       = attr[:sha]
        @author    = attr[:author]
        @committer = attr[:committer]
        @message   = attr[:message]
        @url       = attr[:url]
      end
    end
  end
end
