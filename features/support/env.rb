# encoding: utf-8
require 'aruba/cucumber'
require 'pry'
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

Before do
  @dirs = ['./tmp/aruba']
  @aruba_timeout_seconds = 20
end
