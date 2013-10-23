# encoding: utf-8
require 'helper'
require 'bs/configuration/local_repository'

module BS::Configuration
  describe LocalRepository do

    describe 'valid urls' do
      valid_urls = ['https://github.com/tilljoel/bs.git/',
                    'https://github.com/tilljoel/bs.git',
                    'https://github.com:80/tilljoel/bs.git/',
                    'https://github.com:80/tilljoel/bs.git',
                    'http://github.com/tilljoel/bs.git/',
                    'http://github.com/tilljoel/bs.git',
                    'http://github.com:80/tilljoel/bs.git/',
                    'http://github.com:80/tilljoel/bs.git',
                    'git@github.com:tilljoel/bs.git/',
                    'git@github.com:tilljoel/bs.git',
                    'github.com:tilljoel/bs.git/',
                    'tilljoel@github.com:tilljoel/bs.git/',
                    'ftps://github.com:80/tilljoel/bs.git/',
                    'tilljoel@github.com:tilljoel/bs.git',
                    'github.com:tilljoel/bs.git',
                    'ssh://tilljoel@github.com/~/tilljoel/bs.git/',
                    'ssh://tilljoel@github.com/~/tilljoel/bs.git',
                    'ssh://tilljoel@github.com:80/tilljoel/bs.git/',
                    'ssh://tilljoel@github.com:80/tilljoel/bs.git',
                    'ssh://tilljoel@github.com/tilljoel/bs.git/',
                    'ssh://tilljoel@github.com/tilljoel/bs.git',
                    'ssh://github.com/tilljoel/bs.git/',
                    'ssh://github.com/tilljoel/bs.git',
                    'ssh://github.com:80/tilljoel/bs.git/',
                    'ssh://github.com:80/tilljoel/bs.git',
                    'git://github.com/tilljoel/bs.git/',
                    'git://github.com/tilljoel/bs.git',
                    'git://github.com/~/tilljoel/bs.git/',
                    'git://github.com/~/tilljoel/bs.git',
                    'git://github.com:80/tilljoel/bs.git/',
                    'git://github.com:80/tilljoel/bs.git',
                    'ftp://github.com/tilljoel/bs.git/',
                    'ftp://github.com/tilljoel/bs.git',
                    'ftp://github.com:80/tilljoel/bs.git/',
                    'ftp://github.com:80/tilljoel/bs.git',
                    'ftps://github.com/tilljoel/bs.git/',
                    'ftps://github.com/tilljoel/bs.git',
                    'ftps://github.com:80/tilljoel/bs.git/',
                    'ftps://github.com:80/tilljoel/bs.git',
                    'rsync://github.com/tilljoel/bs.git/',
                    'rsync://github.com/tilljoel/bs.git',
                    'rsync://github.com:80/tilljoel/bs.git/',
                    'rsync://github.com:80/tilljoel/bs.git']

      valid_urls.each do |url|
        describe "#{url}" do
          subject { LocalRepository.new }
          let(:sha) { 'e1e2' * 10 }
          before do
            LocalRepository.any_instance.stubs(:url_from_repository)\
              .returns(url)
            LocalRepository.any_instance.stubs(:get_head_sha)\
              .returns(sha)
          end
          it { subject.head_sha.must_equal   sha }
          it { subject.owner.must_equal      'tilljoel' }
          it { subject.repo.must_equal       'bs' }
        end
      end
    end

    describe 'invalid urls' do
      subject { LocalRepository.new }
      invalid_urls = ['https://example.com/tilljoel/bs.git/',
                      'https://example.com/tilljoel/bs.git',
                      'https://example.com:80/tilljoel/bs.git/',
                      'https://example.com:80/tilljoel/bs.git',
                      'http://example.com/tilljoel/bs.git/',
                      'http://example.com/tilljoel/bs.git',
                      'http://example.com:80/tilljoel/bs.git/',
                      'http://example.com:80/tilljoel/bs.git',
                      'git@example.com:tilljoel/bs.git/',
                      'git@example.com:tilljoel/bs.git',
                      'example.com:tilljoel/bs.git/',
                      'tilljoel@example.com:tilljoel/bs.git/',
                      'ftps://example.com:80/tilljoel/bs.git/',
                      'tilljoel@example.com:tilljoel/bs.git',
                      'example.com:tilljoel/bs.git',
                      'ssh://tilljoel@example.com/~/tilljoel/bs.git/',
                      'ssh://tilljoel@example.com/~/tilljoel/bs.git',
                      'ssh://tilljoel@example.com:80/tilljoel/bs.git/',
                      'ssh://tilljoel@example.com:80/tilljoel/bs.git',
                      'ssh://tilljoel@example.com/tilljoel/bs.git/',
                      'ssh://tilljoel@example.com/tilljoel/bs.git',
                      'ssh://example.com/tilljoel/bs.git/',
                      'ssh://example.com/tilljoel/bs.git',
                      'ssh://example.com:80/tilljoel/bs.git/',
                      'ssh://example.com:80/tilljoel/bs.git',
                      'git://example.com/tilljoel/bs.git/',
                      'git://example.com/tilljoel/bs.git',
                      'git://example.com/~/tilljoel/bs.git/',
                      'git://example.com/~/tilljoel/bs.git',
                      'git://example.com:80/tilljoel/bs.git/',
                      'git://example.com:80/tilljoel/bs.git',
                      'ftp://example.com/tilljoel/bs.git/',
                      'ftp://example.com/tilljoel/bs.git',
                      'ftp://example.com:80/tilljoel/bs.git/',
                      'ftp://example.com:80/tilljoel/bs.git',
                      'ftps://example.com/tilljoel/bs.git/',
                      'ftps://example.com/tilljoel/bs.git',
                      'ftps://example.com:80/tilljoel/bs.git/',
                      'ftps://example.com:80/tilljoel/bs.git',
                      'rsync://example.com/tilljoel/bs.git/',
                      'rsync://example.com/tilljoel/bs.git',
                      'rsync://example.com:80/tilljoel/bs.git/',
                      'rsync://example.com:80/tilljoel/bs.git',
                      '/local_path/bs',
                      '/local_path/bs.git/',
                      'file:///local_path/bs',
                      'file:///local_path/bs.git']
      invalid_urls.each do |url|
        describe "#{url}" do
          subject { LocalRepository.new }
          before do
            LocalRepository.any_instance.stubs(:url_from_repository)\
              .returns(url)
          end
          it { subject.head_sha.must_equal nil }
          it { subject.owner.must_equal    nil }
          it { subject.repo.must_equal     nil }
        end
      end
    end

    describe 'invalid short sha to resolve #1' do
      let(:sha) { 'e1e2e3' }
      let(:url) { 'https://example.com:80/tilljoel/bs.git/' }
      subject { LocalRepository.new.resolve_sha(sha) }
      before do
        LocalRepository.any_instance.stubs(:url_from_repository)\
          .returns(url)
        LocalRepository.any_instance.stubs(:get_head_sha)\
          .returns(sha)
        Rugged::Repository.any_instance.stubs(:lookup)\
          .raises(Rugged::InvalidError)
      end
      it { subject.must_equal nil }
    end

    describe 'invalid short sha to resolve #2' do
      let(:sha) { 'e1e2e3' }
      let(:url) { 'https://example.com:80/tilljoel/bs.git/' }
      subject { LocalRepository.new.resolve_sha(sha) }
      before do
        LocalRepository.any_instance.stubs(:url_from_repository)\
          .returns(url)
        LocalRepository.any_instance.stubs(:get_head_sha)\
          .returns(sha)
        Rugged::Repository.any_instance.stubs(:lookup)\
          .raises(Rugged::OdbError)
      end
      it { subject.must_equal nil }
    end
  end
end
