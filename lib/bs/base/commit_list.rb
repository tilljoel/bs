# encoding: utf-8
require 'active_model'
require_relative 'commit'

module BS
  module Base
    class CommitList < Array
      include ActiveModel::Validations
      validate :check_errors
      attr_accessor :error_message
      attr_accessor :ref
      attr_accessor :owner
      attr_accessor :repo

      def self.build_with_error(attr)
        new.tap do |with_error|
          with_error.error_message = attr.fetch(:error_message)
          with_error.owner         = attr.fetch(:owner)
          with_error.repo          = attr.fetch(:repo)
          with_error.ref           = attr.fetch(:ref)
        end
      end

      def self.build_from_response(attr)
        response = attr.fetch(:response)
        limit    = attr.fetch(:limit)

        commits = response.first(limit).map do |resp|
          Commit.build_from_response(resp)
        end

        new(commits).tap do |without_error|
          without_error.owner = attr.fetch(:owner)
          without_error.repo  = attr.fetch(:repo)
          without_error.ref   = attr.fetch(:ref)
        end
      end

      def check_errors
        errors.add(:base, error_message) if error_message
      end
    end
  end
end
