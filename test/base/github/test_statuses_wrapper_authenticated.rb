# encoding: utf-8
require 'helper'
require 'bs/base/github/statuses_wrapper'

module BS::Base::Github
  describe StatusesWrapper do
    describe '#status_list' do

      let(:github_user) do
        user = ENV['GITHUB_USER']
        user.dup if user
      end

      let(:github_password) do
        password = ENV['GITHUB_PASSWORD']
        password.dup if password
      end

      let(:auth) do
        stub(github_user:     github_user,
             github_password: github_password)
      end

      let(:status_list) { StatusesWrapper.new(auth).status_list(ref, 1) }
      let(:status)      { status_list.first }

      describe 'authenticated api success' do
        describe 'private repo' do
          let(:repo)     { 'shopid' }
          let(:owner)    { 'popgiro' }
          let(:ref)      { 'c81269d3457474d77dc64e2f1ca55293e10b3191' }
          it 'should be allowed' do
            skip('no github password') unless github_password && github_user
            allowed_states = %w(error, success, pending)
            allowed_states.must_include           status.state
            status_list.must_be_instance_of       StatusList
            status.must_be_instance_of            Status
            status.updated_at.must_be_instance_of Time
            status.created_at.must_be_instance_of Time
            status.creator.login.wont_equal       nil
            status.creator.gravatar_id.wont_equal nil
            status.creator.avatar_url.wont_equal  nil
            status.creator.url.wont_equal         nil
            status.sha.must_equal                 ref
            status.url.must_include 'https://api.github.com/repos/'
          end
        end

        describe 'public repo' do
          let(:repo)  { 'ruby' }
          let(:owner) { 'ruby' }
          let(:ref)   { '790bfbf55cfa276bec8fb3465440dc4b26004026' }
          it 'should be allowed' do
            skip('no github password') unless github_password && github_user
            status.success?.must_equal    true
            status.state.must_equal       'success'
          end
        end
      end
    end
  end
end
