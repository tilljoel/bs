# encoding: utf-8
require 'helper'
require 'bs/base/user'

module BS::Base
  describe User do
    let(:avatar_url) do
      'https://secure.gravatar.com/avatar/' \
      '74f896b312b786ee75a18073941e2457?'\
      'd=https://a248.e.akamai.net/assets.github.com'\
      '%2Fimages%2Fgravatars%2Fgravatar-user-420.png'
    end
    let(:email) { 'knu@b2dd03c8-39d4-4d8f-98ff-823fe69b080e' }
    let(:response) do {
      avatar_url: avatar_url,
      url: 'https://github.com/knu',
      id: 10_236,
      login: 'knu',
      name: 'knu',
      email: 'knu@b2dd03c8-39d4-4d8f-98ff-823fe69b080e'
      }
    end
    describe 'with all information' do
      subject { User.new(response) }
      it { subject.avatar_url.must_equal avatar_url }
      it { subject.url.must_equal        'https://github.com/knu' }
      it { subject.id.must_equal         10_236 }
      it { subject.login.must_equal      'knu' }
      it { subject.name.must_equal       'knu' }
      it { subject.email.must_equal      email }
    end

    describe 'without github info' do
      let(:minimal) do
        resp = response.dup
        resp.delete(:id)
        resp.delete(:login)
        resp.delete(:avatar_url)
        resp.delete(:url)
        resp
      end

      subject { User.new(minimal) }
      it { subject.avatar_url.must_equal nil }
      it { subject.url.must_equal        nil }
      it { subject.id.must_equal         nil }
      it { subject.login.must_equal      nil }
      it { subject.name.must_equal       'knu' }
      it { subject.email.must_equal      email }
    end
  end
end
