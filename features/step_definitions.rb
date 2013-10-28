# encoding: utf-8
require 'net/http'
require 'aruba/api'
require_relative '../lib/bs/configuration/local_repository'

World(Aruba::Api)

When /^I run `([^`]*)` with vcr$/ do |cmd|
  step "I run `bundle exec ruby -r'../../features/support/wrap_with_vcr.rb' "\
       "../../bin/#{cmd}`"
end

When /^I run `([^`]*)` with vcr interactively$/ do |cmd|
  step "I run `bundle exec ruby -r'../../features/support/wrap_with_vcr.rb' "\
       "../../bin/#{cmd}` interactively"
end

Then /^the banner should include the version$/ do
  step %(the output should match /version: \\d+\\.\\d+\\.\\d+\.+/)
end

Then /^the output be the version$/ do
  step %(the output should match /version: \\d+\\.\\d+\\.\\d+\.+/)
end

Then /^the banner should include usage$/ do
  step 'the output should match /usage:.+/'
end

Then /^the fetching status should have owner="(.*?)", repo="(.*?)" and ref="(.*?)"$/ do |owner, repo, ref|
  step "the output should match /fetching status for #{owner}.#{repo} @ .{40}/"
end

Given /the environment variable "(.*)" is set to "(.*)"/ do |env, value|
  set_env(env, value)
end

Given /^no local repo is found$/ do
  step %{I successfully run `git init`}
  step %{I successfully run `git config user.email "tilljoel@example.com"`}
  step %{I successfully run `git config user.name "Joel Larsson"`}
end

Given /^the local repo has owner="(.*?)", repo="(.*?)"$/ do |owner, repo|
  step %{I successfully run `git init`}
  step %{I successfully run `git config user.email "tilljoel@example.com"`}
  step %{I successfully run `git config user.name "Joel Larsson"`}
  step %{I successfully run `touch README.md`}
  step %{I successfully run `git add README.md`}
  step %{I successfully run `git commit -m 'Initial commit'`}
  step %{I successfully run `git remote add origin https://github.com/#{owner}/#{repo}.git`}
end
