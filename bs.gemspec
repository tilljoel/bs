$:.unshift File.expand_path("../lib", __FILE__)
require 'bs/version'

Gem::Specification.new do |s|
  s.name              = 'bs'
  s.version           = BS::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = 'bs'
  s.license           = 'MIT'
  s.homepage          = 'http://github.com/tilljoel/bs'
  s.email             = 'tilljoel@gmail.com'
  s.authors           = [ 'Joel Larsson' ]
  s.files             = %w( README.md Rakefile )
  s.files             += Dir.glob('lib/**/*.rb')
  s.files             += Dir.glob('bin/**/*')
  s.files             = `git ls-files`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options      = ['--charset=UTF-8']
  s.test_files        = `git ls-files -- {test,features}/*`.split("\n")
  s.require_path      = 'lib'
  s.description       = 'Check the build status from the command line, fetch continuous integraton status from the Github status API'

  s.add_runtime_dependency 'configliere',    '~> 0.4.18'
  s.add_runtime_dependency 'rugged',         '~> 0.17.0.b6'
  s.add_runtime_dependency 'command_line_reporter', '~> 3.2.1'
  s.add_runtime_dependency 'oj',             '~> 2.1.2'
  s.add_runtime_dependency 'github_api',     '~> 0.10.1'
  s.add_runtime_dependency 'logging',        '~> 1.8.1'
  s.add_runtime_dependency 'activemodel',    '~> 3.2.13'
  s.add_runtime_dependency 'cli-colorize',   '~> 2.0.0'
  s.add_runtime_dependency 'logging',        '~> 1.8.1'
  s.add_runtime_dependency 'gitable',        '~> 0.3.1'

  s.add_development_dependency 'churn',              '~> 0.0.34'
  s.add_development_dependency 'vcr',                '~> 2.4.0'
  s.add_development_dependency 'webmock',            '~> 1.9.3'
  s.add_development_dependency 'simplecov',          '~> 0.7.1'
  s.add_development_dependency 'aruba',              '~> 0.5.2'
  s.add_development_dependency 'mocha',              '~> 0.13.3'
  s.add_development_dependency 'minitest',           '~> 4.4.0'
  s.add_development_dependency 'minitest-focus',     '~>1.0.0'
  s.add_development_dependency 'minitest-reporters', '~> 0.12.0'
  s.add_development_dependency 'cane',               '~> 2.5.2'
  s.add_development_dependency 'cucumber',           '~> 1.3.1'
  s.add_development_dependency 'simplecov',          '~> 0.7.1'
  s.add_development_dependency 'aruba',              '~> 0.5.1'
  s.add_development_dependency 'awesome_print',      '~> 1.1.0'
  s.add_development_dependency 'pry',                '~> 0.9.12'
  s.add_development_dependency 'pry-debugger',       '~> 0.2.2'
  s.add_development_dependency 'rake',               '~> 10.0.4'
  s.add_development_dependency 'rubygems-tasks',     '~> 0.2.4'
end

