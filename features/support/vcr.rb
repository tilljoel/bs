# encoding: utf-8
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = '../../features/fixtures/cassettes'
  c.hook_into :webmock # or :fakeweb
  c.default_cassette_options = { serialize_with: :psych,
                                 record: :new_episodes }
  # c.filter_sensitive_data('<EMAIL>') { SETTINGS['email'] }
  # c.filter_sensitive_data('<TOKEN>') { SETTINGS['oauth_token'] }
  # c.filter_sensitive_data('<BASIC_AUTH>') { SETTINGS['basic_auth'] }
  # c.filter_sensitive_data('<USER>') { SETTINGS['user'] }
end
