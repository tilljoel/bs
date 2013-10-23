# encoding: utf-8
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/cassettes'
  c.hook_into :webmock # or :fakeweb
  c.default_cassette_options =  { serialize_with: :psych,
                                  record: :new_episodes }
end
