# encoding: utf-8
require 'time'
require_relative 'creator'

module BS
  module Base
    class Status
      attr_accessor :creator

      attr_accessor :description,
                    :target_url,
                    :state,
                    :url

      attr_accessor :created_at,
                    :updated_at

      def initialize(commit_status)
        creator = commit_status[:creator]
        @creator = Creator.new(creator)
        @description = commit_status[:description]
        @state       = commit_status[:state]
        @target_url  = commit_status[:target_url]
        @url         = commit_status[:url]
        @created_at  = Time.parse(commit_status[:created_at])
        @updated_at  = Time.parse(commit_status[:updated_at])
      end

      def success?
        state == 'success'
      end
    end
  end
end
