# encoding: utf-8
require 'bundler'
Bundler.setup

require_relative '../../lib/bs/base/repo'
require_relative 'vcr'

module BS::Base
  class Repo
    alias_method :commit_list_old, :commit_list
    def commit_list(ref, limit = 2)
      s = nil
      VCR.use_cassette("#{owner}_#{repo}_#{ref}") do
        s = commit_list_old(ref, limit)
      end
      s
    end
  end
end
