# encoding: utf-8

require 'rugged'
require 'English'
require 'gitable/uri'
require_relative 'log_handler'

module BS::Configuration
  class LocalRepository
    attr_accessor :repo, :owner, :head_sha
    attr_accessor :url
    def initialize

      @url = url_from_repository
      return unless @url

      uri = Gitable::URI.parse(@url)
      return unless uri.github?

      @owner    = get_owner(uri.path)
      @repo     = get_repo(uri.path)
      @head_sha = get_head_sha(repository)
    rescue Rugged::RepositoryError, Rugged::Error
      @owner = nil
      @repo = nil
      @head_sha = nil
    end

    def resolve_sha(short_sha)
      commit = repository.lookup(short_sha)
      commit.oid if commit
    rescue Rugged::InvalidError, Rugged::OdbError
      nil
    end

    private

    def get_repo(path)
      parts = path.split('/')
      parts[-1].gsub('.git', '')
    end

    def get_owner(path)
      parts = path.split('/')
      parts[-2]
    end

    def get_head_sha(repository)
      repository.head.target
    end

    def url_from_repository
      Rugged::Remote.each(repository) do |remote_name|
        remote = Rugged::Remote.new(repository, remote_name)
        return remote.url
      end
    end

    def repository
      @repository ||= Rugged::Repository.new(current_git_dir)
    end

    def current_git_dir
      @current_git_dir ||= Rugged::Repository.discover(current_dir)
    end

    def current_dir
      @current_dir ||= Dir.pwd
    end
  end
end
