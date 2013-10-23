# encoding: utf-8
require 'helper'
require 'bs/base/commit'

module BS::Base
  describe Commit do
    let(:response) do {
      sha: 'ccb34ee954409f5856eb74c2ce9682bf5e40f17f',
      commit: {
        author: {
          name: 'joel author',
          email: 'tilljoel@b2dd03c8-39d4-4d8f-98ff-823fe69b080e',
          date: '2012-05-21T07:28:54Z'
        },
        committer: {
          name: 'joel committer',
          email: 'tilljoel@b2dd03c8-39d4-4d8f-98ff-823fe69b080e',
          date: '2012-05-21T07:28:54Z'
        },
        message: '* ext/syslog/syslog.c (mSyslog_inspect): Make sure self is a\n  module before calling rb_class2name().\n\n\n\n\ngit-svn-id: svn+ssh://ci.ruby-lang.org/ruby/branches/ruby_1_9_2@35742 b2dd03c8-39d4-4d8f-98ff-823fe69b080e',
        tree: {
          sha: '055fdc949cb3ff9225ba518c6b9e053eef698822',
          url: 'https://api.github.com/repos/ruby/ruby/git/trees/055fdc949cb3ff9225ba518c6b9e053eef698822'
        },
        url: 'https://api.github.com/repos/ruby/ruby/git/commits/ccb34ee954409f5856eb74c2ce9682bf5e40f17f',
        comment_count: 0
      },
      url: 'https://api.github.com/repos/ruby/ruby/commits/ccb34ee954409f5856eb74c2ce9682bf5e40f17f',
      html_url: 'https://github.com/ruby/ruby/commit/ccb34ee954409f5856eb74c2ce9682bf5e40f17f',
      comments_url: 'https://api.github.com/repos/ruby/ruby/commits/ccb34ee954409f5856eb74c2ce9682bf5e40f17f/comments',
      author: {
        login: 'tilljoel',
        id: 1000,
        avatar_url: 'https://secure.gravatar.com/avatar/74f896b312b786ee75a18073941e2457?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png',
        gravatar_id: '74f896b312b786ee75a18073941e2457',
        url: 'https://api.github.com/users/tilljoel',
        html_url: 'https://github.com/tilljoel',
        followers_url: 'https://api.github.com/users/tilljoel/followers',
        following_url: 'https://api.github.com/users/tilljoel/following',
        gists_url: 'https://api.github.com/users/tilljoel/gists{/gist_id}',
        starred_url: 'https://api.github.com/users/tilljoel/starred{/owner}{/repo}',
        subscriptions_url: 'https://api.github.com/users/tilljoel/subscriptions',
        organizations_url: 'https://api.github.com/users/tilljoel/orgs',
        repos_url: 'https://api.github.com/users/tilljoel/repos',
        events_url: 'https://api.github.com/users/tilljoel/events{/privacy}',
        received_events_url: 'https://api.github.com/users/tilljoel/received_events',
        type: 'User'
      },
      committer: {
        login: 'tilljoel',
        id: 1001,
        avatar_url: 'https://secure.gravatar.com/avatar/74f896b312b786ee75a18073941e2457?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png',
        gravatar_id: '74f896b312b786ee75a18073941e2457',
        url: 'https://api.github.com/users/tilljoel',
        html_url: 'https://github.com/tilljoel',
        followers_url: 'https://api.github.com/users/tilljoel/followers',
        following_url: 'https://api.github.com/users/tilljoel/following',
        gists_url: 'https://api.github.com/users/tilljoel/gists{/gist_id}',
        starred_url: 'https://api.github.com/users/tilljoel/starred{/owner}{/repo}',
        subscriptions_url: 'https://api.github.com/users/tilljoel/subscriptions',
        organizations_url: 'https://api.github.com/users/tilljoel/orgs',
        repos_url: 'https://api.github.com/users/tilljoel/repos',
        events_url: 'https://api.github.com/users/tilljoel/events{/privacy}',
        received_events_url: 'https://api.github.com/users/tilljoel/received_events',
        type: 'User'
      },
      parents: [
        {
          sha: '2c2b8637c39969bb870e74d313dc376a79167e9a',
          url: 'https://api.github.com/repos/ruby/ruby/commits/2c2b8637c39969bb870e74d313dc376a79167e9a',
          html_url: 'https://github.com/ruby/ruby/commit/2c2b8637c39969bb870e74d313dc376a79167e9a'
        }
      ]}
    end
    describe 'with all information' do
      subject { Commit.build_from_response(response) }
      it { subject.sha.must_equal 'ccb34ee954409f5856eb74c2ce9682bf5e40f17f' }
      it { subject.message.must_include 'ext/syslog/syslog.c' }
      it { subject.url.must_equal 'https://github.com/ruby/ruby/commit/ccb34ee954409f5856eb74c2ce9682bf5e40f17f' }
      describe 'correct author/committer' do
        let(:expected_author_argument) do
          {
            avatar_url: 'https://secure.gravatar.com/avatar/74f896b312b786ee75a18073941e2457?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png',
            url:        'https://github.com/tilljoel',
            id:         1000,
            login:      'tilljoel',
            name:       'joel author',
            email:      'tilljoel@b2dd03c8-39d4-4d8f-98ff-823fe69b080e'
          }
        end
        let(:expected_committer_argument) do
          {
            avatar_url: 'https://secure.gravatar.com/avatar/74f896b312b786ee75a18073941e2457?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png',
            url:        'https://github.com/tilljoel',
            id:         1001,
            login:      'tilljoel',
            name:       'joel committer',
            email:      'tilljoel@b2dd03c8-39d4-4d8f-98ff-823fe69b080e'
          }
        end
        it 'creates two new User' do
          User.expects(:new).with(expected_committer_argument).once
          User.expects(:new).with(expected_author_argument).once
          Commit.build_from_response(response)
        end
      end
    end

    describe 'without github info' do
      let(:minimal) do
        resp = response.dup
        resp.delete(:committer)
        resp.delete(:author)
        resp
      end
      subject { Commit.build_from_response(minimal) }
      let(:expected_author_argument) do
        {
          avatar_url: nil,
          url:        nil,
          id:         nil,
          login:      nil,
          name:       'joel author',
          email:      'tilljoel@b2dd03c8-39d4-4d8f-98ff-823fe69b080e'
        }
      end
      let(:expected_committer_argument) do
        {
          avatar_url: nil,
          url:        nil,
          id:         nil,
          login:      nil,
          name:       'joel committer',
          email:      'tilljoel@b2dd03c8-39d4-4d8f-98ff-823fe69b080e'
        }
      end
      it 'creates a new User as author' do
        User.expects(:new).with(expected_committer_argument).once
        User.expects(:new).with(expected_author_argument).once
        Commit.build_from_response(minimal)
      end
    end
  end
end

