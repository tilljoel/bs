# encoding: utf-8

require 'helper'
require 'vcr_helper'
require 'webmock/minitest'
require 'bs/base/github/statuses_wrapper'
require 'bs/base/repo'

module BS::Base::Github
  include BS::Base
  describe StatusesWrapper do

    describe '#status_list' do
      let(:owner)             { 'ruby' }
      let(:repo)              { 'ruby' }
      let(:ref)               { '790bfbf55cfa276bec8fb3465440dc4b26004026' }
      let(:base_repo)         { Repo.new(config) }
      let(:statuses_wrapper)  { StatusesWrapper.new(base_repo) }
      let(:status_list)       { statuses_wrapper.status_list(ref) }
      let(:status)            { status_list.first }
      let(:config) do
        stub(owner: owner,
             repo: repo,
             github_user: nil,
             github_password: nil)
      end

      describe 'api success' do
        before do
          VCR.insert_cassette("repo_status--#{owner}_#{repo}_#{ref}")
        end
        after do
          VCR.eject_cassette
        end

        describe 'ci error' do
          let(:ref) { '77b885264bda990e13fe385199f31c90e0ae668a' }
          specify { status.state.must_equal                'error' }
          specify { status.success?.must_equal             false }

          specify { status_list.must_be_instance_of        StatusList }
          specify { status.must_be_instance_of             Status }
          specify { status.creator.avatar_url.must_include 'gravatar.com' }
          specify { status.creator.gravatar_id.must_equal  '540cb3b3712ffe045113cb03bab616a2' }
          specify { status.creator.login.must_equal        'evanphx' }
          specify { status.creator.id.must_equal           7 }
          specify { status.creator.url.must_equal          'https://api.github.com/users/evanphx' }
          specify { status.description.must_equal          'The Travis build could not complete due to an error' }
          specify { status.url.must_equal                  'https://api.github.com/repos/ruby/ruby/statuses/77b885264bda990e13fe385199f31c90e0ae668a' }
          specify { status.target_url.must_equal           'https://travis-ci.org/ruby/ruby/builds/5766380' }
          specify { status.url.must_equal                  'https://api.github.com/repos/ruby/ruby/statuses/77b885264bda990e13fe385199f31c90e0ae668a' }
          specify { status.created_at.must_equal            Time.new(2013, 3, 24, 22, 7, 58, '+00:00').utc }
          specify { status.updated_at.must_equal            Time.new(2013, 3, 24, 22, 7, 58, '+00:00').utc }
        end

        describe 'ci success' do
          let(:ref) { '790bfbf55cfa276bec8fb3465440dc4b26004026' }
          specify { status.success?.must_equal             true }
          specify { status.state.must_equal                'success' }

          specify { status_list.must_be_instance_of        StatusList }
          specify { status.must_be_instance_of             Status }
          specify { status.creator.avatar_url.must_include 'gravatar.com' }
          specify { status.creator.gravatar_id.must_equal  '540cb3b3712ffe045113cb03bab616a2' }
          specify { status.creator.login.must_equal        'evanphx' }
          specify { status.creator.id.must_equal           7 }
          specify { status.creator.url.must_equal          'https://api.github.com/users/evanphx' }
          specify { status.description.must_equal          'The Travis build passed' }
          specify { status.url.must_equal                  'https://api.github.com/repos/ruby/ruby/statuses/790bfbf55cfa276bec8fb3465440dc4b26004026' }
          specify { status.target_url.must_equal           'https://travis-ci.org/ruby/ruby/builds/5072032' }
          specify { status.updated_at.must_equal            Time.new(2013, 2, 26, 14, 47, 33, '+00:00').utc }
          specify { status.created_at.must_equal            Time.new(2013, 2, 26, 14, 47, 33, '+00:00').utc }
        end
      end

      describe 'api failure' do
        before { VCR.insert_cassette("repo_status--#{owner}_#{repo}_#{ref}") }
        after { VCR.eject_cassette }

        describe 'invalid resource' do

          describe 'invalid ref' do
            let(:ref) { 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' }
            it 'has a statuses with errors' do
              status_list.invalid?.must_equal true
              status_list.errors[:base].first.must_include 'no statuses found'
            end
          end

          describe 'invalid owner' do
            let(:owner) { 'example' }
            it 'has a statuses with errors' do
              status_list.invalid?.must_equal true
              status_list.errors[:base].first.must_include '404 Not Found'
            end
          end

          describe 'invalid repo' do
            let(:repo) { 'example' }
            it 'has a statuses with errors' do
              status_list.invalid?.must_equal true
              status_list.errors[:base].first.must_include '404 Not Found'
            end
          end

          describe 'unauthorized repo' do
            let(:owner) { 'popgiro' }
            let(:repo)  { 'website' }
            let(:ref)   { '535d808787b65427e763e43bfb768e48df68423e' }

            describe 'without credentials' do
              it 'has a statuses with errors' do
                status_list.invalid?.must_equal true
                status_list.errors[:base].first.must_include '404 Not Found'
              end
            end

            describe 'with invalid credentials' do
              let(:config) do
                stub(owner: owner,
                     repo: repo,
                     github_user: 'example',
                     github_password: 'example')
              end

              it 'has a statuses with errors' do
                status_list.invalid?.must_equal true
                status_list.errors[:base].first.must_include '401 Bad credentials'
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

        describe 'statuses resource timeout' do
          before do
            url = "https://api.github.com/repos/#{owner}/#{repo}/statuses/#{ref}"
            stub_request(:get, url).to_timeout
          end

          it 'has a statuses with errors' do
            status_list.invalid?.must_equal true
            status_list.errors[:base].first.must_include 'execution expired'
          end
        end

        [401, 404, 406, 422, 500, 503, 555].each do |error|
           describe "http error #{error}" do
             before do
               url = "https://api.github.com/repos/#{owner}/#{repo}/statuses/#{ref}"
               stub_request(:get, url).to_return({:body => '', :status => error})
             end

             it "has error: #{error}" do
               status_list.invalid?.must_equal true
               status_list.errors[:base].first.must_include "#{error}"
             end
           end
         end
      end
    end
  end
end
