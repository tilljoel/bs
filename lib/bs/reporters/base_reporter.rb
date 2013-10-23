# encoding: utf-8
require 'active_support/inflector'

module BS::Reporters
  class BaseReporter
    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def self.reporter_name
      name.demodulize
    end

    def self.config_name
      reporter_name.underscore.gsub(/_reporter$/, '')
    end

    def report(config)
      # report commit/status
    end

    def report_settings(commits)
      # report settings before runnint
    end

    private

    def is_sha?(ref)
      /^[0-9a-f]{40}$/ === ref
    end

    def shorten_if_sha(ref)
      if is_sha?(ref)
        ref[0...6]
      else
        ref
      end
    end
  end
end
