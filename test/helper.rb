# encoding: utf-8
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'minitest/unit'
require 'minitest/mock'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/focus'
require 'mocha/setup'

puts "Running specs in version #{RUBY_VERSION}" +
     " on #{RUBY_PLATFORM} #{RUBY_DESCRIPTION}"
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

# MiniTest::Reporters.use! MiniTest::Reporters::DefaultReporter.new
# MiniTest::Unit.runner =  MiniTest::Unit.new
# MiniTest::Unit.runner.reporters << MiniTest::Reporters::ProgressReporter.new
# MiniTest::Unit.runner.reporters << MiniTest::Reporters::DefaultReporter.new
# MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

class MiniTest::Unit::TestCase
end

require 'simplecov'

class SimpleCov::Formatter::QualityFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    File.open('coverage/covered_percent', 'w') do |f|
      f.puts result.source_files.covered_percent.to_i
    end
  end
end

SimpleCov.formatter = SimpleCov::Formatter::QualityFormatter
SimpleCov.use_merging true
SimpleCov.merge_timeout 3600
SimpleCov.start do
  add_filter '/test/'
  add_filter '/features/'
end

def reset_env_variables
  ENV['BS_CONFIG'] = nil
  ENV['BS_GITHUB_PASSWORD'] = nil
  ENV['BS_GITHUB_USER'] = nil
  ENV['BS_LIMIT'] = nil
  ENV['BS_LOG_LEVEL'] = nil
  ENV['BS_OWNER'] = nil
  ENV['BS_REPO'] = nil
  ENV['BS_REPORTER'] = nil
  ENV['BS_SHA'] = nil
  ENV['BS_VERBOSE'] = nil
end

# XXX Settings.value is keept between tests, be sure to empty env
#     before we require configliere
reset_env_variables
require 'configliere'

MiniTest::Unit.autorun
