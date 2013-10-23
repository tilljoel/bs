# encoding: utf-8
require 'helper'
require 'vcr_helper'
require 'webmock/minitest'
require 'bs/base/repo'
require 'bs/base/user'
require 'bs/base/github/commits_wrapper'

module BS::Base::Github
  include BS::Base
  describe CommitsWrapper do

    describe '#commit_list' do

      let(:config) do
        stub(owner: owner,
             repo: repo,
             github_user: nil,
             github_password: nil)
      end

      let(:repo)            { 'ruby' }
      let(:owner)           { 'ruby' }
      let(:ref)             { '790bfbf55cfa276bec8fb3465440dc4b26004026' }
      let(:base_repo)       { Repo.new(config) }
      let(:commits_wrapper) { CommitsWrapper.new(base_repo) }
      let(:commit_list)     { commits_wrapper.commit_list(ref) }
      let(:first)           { commit_list.first }

      describe 'api success' do
        before { VCR.insert_cassette("repo_commits--#{owner}_#{repo}_#{ref}") }
        after { VCR.eject_cassette }

        describe 'ci error' do
          let(:ref) { '77b885264bda990e13fe385199f31c90e0ae668a' }
          specify { commit_list.valid?.must_equal        true }
          specify { commit_list.count.must_equal         2 }
          specify { commit_list.must_be_instance_of      CommitList }
          specify { first.must_be_instance_of            Commit }
          specify { first.url.must_include               'https://github.com/' }
          specify { first.sha.must_equal                 '77b885264bda990e13fe385199f31c90e0ae668a' }
          specify { first.author.must_be_instance_of     User }
          specify { first.committer.must_be_instance_of  User }
          specify { first.message.must_include           'test/rinda/test_rinda.rb' }
        end

        describe 'ci success' do
          let(:ref) { '790bfbf55cfa276bec8fb3465440dc4b26004026' }
          specify { commit_list.count.must_equal         2 }
          specify { commit_list.valid?.must_equal        true }
          specify { commit_list.must_be_instance_of      CommitList }
          specify { first.must_be_instance_of            Commit }
          specify { first.url.must_include               'https://github.com/' }
          specify { first.sha.must_equal                 '790bfbf55cfa276bec8fb3465440dc4b26004026' }
          specify { first.author.must_be_instance_of     User }
          specify { first.committer.must_be_instance_of  User }
          specify { first.message.must_include           'Fix typos... Sorry...' }
        end
      end

      describe 'api failure' do
        before { VCR.insert_cassette("repo_commits--#{owner}_#{repo}_#{ref}") }
        after { VCR.eject_cassette }

        describe 'invalid resource' do

          describe 'invalid ref' do
            let(:ref) { 'deadbeafdeadbeafdeafbeafdeadbeafdeadbeaf' }
            it 'has correct errors' do
              commit_list.invalid?.must_equal true
              commit_list.errors[:base].first.must_include '404 Not Found'
            end
          end

          describe 'invalid owner' do
            let(:owner) { 'example' }
            it 'has correct errors' do
              commit_list.invalid?.must_equal true
              commit_list.errors[:base].first.must_include '404 Not Found'
            end
          end

          describe 'invalid repo' do
            let(:repo) { 'example' }
            it 'has correct errors' do
              commit_list.invalid?.must_equal true
              commit_list.errors[:base].first.must_include '404 Not Found'
            end
          end

          describe 'unauthorized repo' do
            let(:owner) { 'popgiro' }
            let(:repo)  { 'website' }
            let(:ref)   { '535d808787b65427e763e43bfb768e48df68423e' }

            describe 'without credentials' do
              it 'has correct errors' do
                commit_list.invalid?.must_equal true
                commit_list.errors[:base].first.must_include '404 Not Found'
              end
            end

          end
        end
      end

      describe 'network failure' do

        before do
          VCR.turn_off!
        end

        after do
          VCR.turn_on!
          WebMock.reset!
        end

        describe 'timeout resource' do

          before do
            url = "https://api.github.com/repos/#{owner}/#{repo}/commits?sha=#{ref}"
            stub_request(:get, url).to_timeout
          end

          it 'has correct errors' do
            commit_list.valid?.must_equal false
            commit_list.errors[:base].first.must_include 'execution expired'
          end
        end

        [401, 404, 406, 422, 500, 503, 555].each do |error|
          describe "http error #{error}" do
            before do
              url = "https://api.github.com/repos/#{owner}/#{repo}/commits?sha=#{ref}"
              stub_request(:get, url).to_return({ body: '', status: error })
            end

            it "has error: #{error}" do
              commit_list.valid?.must_equal false
              commit_list.errors[:base].first.must_include "#{error}"
            end
          end
        end
      end
    end
  end
end
