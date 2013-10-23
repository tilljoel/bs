# encoding: utf-8
require 'helper'
require 'vcr_helper'
require 'bs/application'

module BS
  describe Application do
    let(:owner)  { 'ruby' }
    let(:repo)   { 'ruby' }
    let(:ref)    { '790bfbf55cfa276bec8fb3465440dc4b26004026' }
    subject { Application.new }

    before do
      config = stub(owner: owner,
                    repo: repo,
                    ref: ref,
                    reporter: :none,
                    log_level: :INFO,
                    version: false,
                    limit: 1,
                    github_user: nil,
                    github_password: nil)
      Application.any_instance.stubs(:config).returns(config)
      Application.any_instance.stubs(:init_configuration).returns(nil)
    end

    describe '#run' do
      before do
        VCR.insert_cassette("repo_status--#{owner}_#{repo}_#{ref}")
      end
      after do
        VCR.eject_cassette
      end

      it 'should run' do
        lambda do
          _out, _err = capture_io { subject.run }
        end.must_raise SystemExit
      end
    end
  end
end
