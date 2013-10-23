# encoding: utf-8
require 'active_model'
require_relative 'status'

module BS
  module Base
    class StatusList < Array
      include ActiveModel::Validations
      validate :check_errors
      attr_accessor :error_message

      def self.build_with_error(attr)
        new.tap do |with_error|
          with_error.error_message = attr.fetch(:error_message)
        end
      end

      def self.build_from_response(response)

        statuses = response.map { |resp| Status.new(resp) }

        if response == []
          build_with_error(error_message: 'no statuses found')
        else
          new(statuses)
        end
      end

      def check_errors
        errors.add(:base, error_message) if error_message
      end
    end
  end
end
