# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'churn'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'rake/testtask'
require 'cucumber'
require 'cucumber/rake/task'
require 'rubygems/tasks'
Gem::Tasks.new

Rake::TestTask.new(:test) do |test|
  files = Dir['test/**/test_*.rb'].reject{ |f| f[%r{_authenticated.rb}] }
  test.libs << 'lib' << 'test'
  test.test_files = files
  test.verbose = true
end

Rake::TestTask.new(:test_with_authentication) do |test|
  files = Dir['test/**/test_*.rb'].select{ |f| f[%r{_authenticated.rb}] }
  test.libs << 'lib' << 'test'
  test.test_files = files
  test.verbose = true
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

begin
  require 'cane/rake_task'

  desc "Run cane to check quality metrics"
  Cane::RakeTask.new(:quality) do |cane|
    cane.abc_max = 22
    cane.add_threshold 'coverage/covered_percent', :>=, 40
    cane.abc_glob = '{lib,test}/**/*.rb'
    cane.no_doc = true
    cane.style_glob = '{lib}/**/*.rb'
#    cane.no_style = true
#    cane.abc_exclude = %w(Foo::Bar#some_method)
  end

#  task :default => :quality
rescue LoadError
  warn "cane not available, quality task not provided."
end


task :default => :all

task :all do |t|
  Rake::Task["test"].invoke
  Rake::Task["features"].invoke
  Rake::Task["quality"].invoke
end
