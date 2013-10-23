# encoding: utf-8
require 'helper'
require 'bs/base/status_list'
require 'bs/base/status'

module BS::Base
  describe StatusList do
    let(:response) { [1, 2, 3] }

    describe '#new' do
      describe 'with arguments' do
        subject { StatusList.new([1, 2, 3, 4]) }
        specify { subject.valid?.must_equal true }
      end
      describe 'with no' do
        subject { StatusList.new }
        specify { subject.valid?.must_equal true }
      end
    end

    describe '#build_with_error' do
      let(:opts) do
        { error_message: 'error message' }
      end

      subject { StatusList.build_with_error(opts) }
      it 'has correct error message' do
        subject.invalid?.must_equal true
        subject.errors[:base].must_include 'error message'
      end
    end

    describe '#build_from_response' do
      before do
        Status.expects(:new).times(3)
      end
      subject { StatusList.build_from_response(response) }
      specify { subject.valid?.must_equal true }
      specify { subject.count.must_equal 3 }
    end
  end
end
