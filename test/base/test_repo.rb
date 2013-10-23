# encoding: utf-8
require 'helper'
require 'vcr_helper'
require 'webmock/minitest'
require 'bs/base/repo'

module BS::Base
  describe Repo do

    describe '#commit_list' do
      subject           { Repo.new(config) }
      let(:owner)       { 'ruby' }
      let(:repo)        { 'ruby' }
      let(:ref)         { '790bfbf55cfa276bec8fb3465440dc4b26004026' }
      let(:commit_list) { subject.commit_list(ref, 3) }
      let(:status_list) { commit_list.first.status_list }
      let(:config) do
        stub(owner: owner,
             repo: repo,
             github_user: nil,
             github_password: nil)
      end

      describe 'should have embedded status_list' do
        before do
          VCR.insert_cassette("repo_status--#{owner}_#{repo}_#{ref}")
        end
        after do
          VCR.eject_cassette
        end

        describe 'ci error' do
          let(:ref) { '77b885264bda990e13fe385199f31c90e0ae668a' }
          specify { commit_list.must_be_instance_of CommitList }
          specify { status_list.must_be_instance_of StatusList }
          specify { commit_list.length.must_equal   3 }
          specify { status_list.length.must_equal   2 }
        end

        describe 'ci success' do
          let(:ref) { '790bfbf55cfa276bec8fb3465440dc4b26004026' }
          specify { commit_list.must_be_instance_of CommitList }
          specify { status_list.must_be_instance_of StatusList }
          specify { commit_list.length.must_equal   3 }
          specify { status_list.length.must_equal   2 }
        end
      end
    end
  end
end
