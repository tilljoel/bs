# encoding: utf-8
require 'helper'
require 'bs/base/commit_list'

module BS::Base
  describe CommitList do
    let(:response) { [1, 2, 3] }
    let(:ref) { '790bfbf55cfa276bec8fb3465440dc4b26004026' }

    describe '#new' do
      describe 'with arguments' do
        subject { CommitList.new([1, 2, 3, 4]) }
        specify { subject.valid?.must_equal true }
      end
      describe 'with no' do
        subject { CommitList.new }
        specify { subject.valid?.must_equal true }
      end
    end

    describe '#build_with_error' do
      let(:opts) do { ref: ref,
                      error_message: 'error message',
                      repo: 'name',
                      owner: 'owner' }
      end
      subject { CommitList.build_with_error(opts) }
      it 'has correct error message' do
        subject.invalid?.must_equal true
        subject.errors[:base].must_include 'error message'
      end
    end

    describe '#build_from_response' do
      let(:limit) { 3 }
      let(:opts) do { ref: ref,
                      owner: 'owner',
                      repo: 'name',
                      response: response,
                      limit: limit }
      end
      before do
        Commit.expects(:build_from_response).times(limit)
      end
      subject { CommitList.build_from_response(opts) }
      specify { subject.valid?.must_equal true }
      specify { subject.count.must_equal 3 }

      describe 'with limit' do
        let(:limit) { 2 }
        specify { subject.valid?.must_equal true }
        specify { subject.count.must_equal 2 }
      end
    end
  end
end
