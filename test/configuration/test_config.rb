# encoding: utf-8
require 'helper'
require 'bs/configuration/config'

module BS::Configuration
  describe Config do
    subject { Settings }
    let(:owner) { 'ruby' }
    let(:repo)  { 'ruby' }
    let(:ref)   { '32d416db0db4e445d8156885aae9c6b26ce56c56' }

    let(:local_repo) do
      stub(owner: owner,
           repo: repo,
           head_sha: ref)
    end

    before do
      reset_env_variables
      LocalRepository.stubs(:new).returns(local_repo)
    end

    describe 'configuration hierarchy' do
      describe 'values from local repo' do

        before do
          reset_env_variables
          Config.new
        end

        it { subject.github_password.must_equal nil }
        it { subject.github_user.must_equal     nil }
        it { subject.owner.must_equal           owner }
        it { subject.repo.must_equal            repo }
        it { subject.ref.must_equal             ref }
        it { subject.log_level.must_equal       :WARN }
        it { subject.config.must_equal          nil }
        it { subject.verbose.must_equal         false }
        it { subject.reporter.must_equal        'default' }

        describe 'environment overide local repo values' do
          before do
            ENV['BS_GITHUB_PASSWORD'] = 'github_password_from_env'
            ENV['BS_GITHUB_USER']     = 'github_user_from_env'
            ENV['BS_LIMIT']           = '5'
            ENV['BS_LOG_LEVEL']       = 'DEBUG'
            ENV['BS_OWNER']           = 'owner_from_env'
            ENV['BS_REPO']            = 'repo_from_env'
            Config.new
          end

          it { subject.github_password.must_equal 'github_password_from_env' }
          it { subject.github_user.must_equal     'github_user_from_env' }
          it { subject.owner.must_equal           'owner_from_env' }
          it { subject.repo.must_equal            'repo_from_env' }
          it { subject.log_level.must_equal       'DEBUG' }

          describe 'arguments overide environment values' do
            before do
              ::ARGV.replace ['the_command',
                              '--owner=tilljoel',
                              '--repo=bs']
              Config.new
            end

            it { subject.owner.must_equal 'tilljoel' }
            it { subject.repo.must_equal  'bs' }
          end
        end
      end
    end

    describe 'coerce config values' do
      let(:full_sha) { '12ab' * 10 }
      let(:ref)      { '12ab12' }
      before do
        local_repo.stubs(:resolve_sha).returns(full_sha)
        Config.new
      end
      it 'should resolve shortened sha values to full 40 chars' do
        subject.ref.must_equal full_sha
      end
      it 'should handle log_level strings of and coerece to symbol' do
      end
    end

    describe 'fails on no valid values' do
      it 'shold fail on non-correct sha-1 format' do
      end
      it 'it should fail on non-numeric limit' do
      end
    end
  end
end
