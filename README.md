[![Build Status](https://travis-ci.org/tilljoel/bs.png?branch=master)](https://travis-ci.org/tilljoel/bs)
[![Code Climate](https://codeclimate.com/github/tilljoel/bs.png)](https://codeclimate.com/github/tilljoel/bs)

# BS - Build Status

* __Who broke the build?__
* __Does this branch build?__
* __When was the last green build?__

`bs` is a command line tool that helps you to access the [Github Status
API](http://developer.github.com/v3/repos/statuses/).

## About


The Status API allows external services to mark commits with a _success_,
_failure_, _error_, or _pending_ state. Most common use case is a continuous
integration services like [Circle CI](https://circleci.com/), [Semaphore](https://semaphoreapp.com/) or
[Travic CI](https://travis-ci.org/)

## Installation

`gem install bs`

## Usage

Just run `bs` in a directory, or add some arguments to specify a github
commit; `--repo`, `--owner`, `--ref`

### Some examples


```bash
# Does my current commits build? No arguments or env variables set, so
# use the current git repo to find owner, repo and ref

> bs

fetching status for ruby/ruby @ 418bbce88a77599672a5851f63245a4723a8a608

ruby/ruby @ 418bbc - success

```

```bash
# Before I pull, check if trunk branch builds, owner and repo is from the
# current git repo

> bs --ref=trunk

fetching status for ruby/ruby @ trunk

ruby/ruby @ a0c671 - success

```

```bash
# What commit broke the build? Check last 5 commits for build status

> bs --ref=trunk --limit=5

fetching status for ruby/ruby @ trunk

ruby/ruby @ 341a1a - failure
ruby/ruby @ 139d4b - failure
ruby/ruby @ 449d41 - success
ruby/ruby @ 459d4e - failure
ruby/ruby @ 32e1d1 - failure

# check backwards until we find a successful build status

> bs --ref=trunk --blame

ruby/ruby @ 341a1a - failure
ruby/ruby @ 139d4b - failure
ruby/ruby @ 449d41 - success
```


```bash
# Does another fork of this repo build?

> bs --owner=tilljoel --ref=trunk

fetching status for ruby/ruby @ trunk

ruby/ruby @ 3432e1 - success
```


```bash
# Does a specific sha of this repo build?

> bs --ref=dd117e

fetching status for ruby/ruby @ dd117ea1182cfaa96fa84e60c25452cde075acc4

ruby/ruby @ dd117e - no status set
```

## Settings

Configuration is possible in 4 different levels, that override each
other in the following order.

1. owner, repo, sha from local repository
2. config file
3. environment variables
4. commandline arguments

### Help

```bash

> bs --help

usage: bs [...--param=val...]

Show continuous integraton build status from the Github status API'

version: 0.0.1
```

Command flag                    | Description
--------------------------------|----------------------------------------------------------------------------------
 `-f, --config=filename`        | Custom config file [Env Var: BS_CONFIG]
 `-p, --github_password=String` | Github password to use for authentication [Env Var: BS_GITHUB_PASSWORD]
 `-u, --github_user=String`     | Github username to use for authentication [Env Var: BS_GITHUB_USER]
 `-c, --limit=Integer`          | Number of commits to fetch status from,up to sha [Default: 1] [Env Var: BS_LIMIT]
 `-l, --log_level=String`       | Try: DEBUG, INFO, WARN, ERROR, FATAL [Default: WARN] [Env Var: BS_LOG_LEVEL]
 `-o, --owner=String`           | Github repository owner/username [Required] [Env Var: BS_OWNER]
 `-s, --ref=String`             | Commit sha, branch or tag  (or partial sha for local repo) [Env Var: BS_REF]
 `-r, --repo=String`            | Github repository name [Required] [Env Var: BS_REPO]
 `-V, --verbose`                | Print more commit status information [Env Var: BS_VERBOSE]
 `-v, --version`                | Print version [Env Var: BS_VERBOSE]
 `--reporter=String`            | Try: default_no_color, default, full, none, minimal [Default: default] [Env Var: BS_REPORTER]

### Authentication
Alias `bs` to something like ``bs --github_password=`keychain_password
github``` or add your github info to the env, but its not recommended.

```bash
export BS_GITHUB_USER='tilljoel'
export BS_GITHUB_PASSWORD='xxxx'
```

## Other use-cases

I currently use it with powerline and tmux to show build status
in my powerline prompt.

## For developers

Add issues to github or help me fix them.

### Gotchas

A commit can have multiple statuses, a status can have 4 different values
according to the [github api](http://developer.github.com/v3/repos/statuses/)

* pending
* success
* error
* failure

`bs` will add two new status values

* no status
* network error

Not all commits contain status data and most services write a `pending` status when they start the build, then a new status
when the build is complete.

### Tools

run [rubocop](https://github.com/bbatsov/rubocop) with the supplied `.rubocop.yml` or try any of the rake tasks.

```bash

> rake -T

rake build                     # Builds all packages
rake churn                     # Report the current churn for the project
rake console                   # Spawns an Interactive Ruby Console
rake features                  # Run Cucumber features
rake install                   # Installs all built gem packages
rake quality                   # Run cane to check quality metrics
rake release                   # Performs a release
rake test                      # Run tests
rake test_with_authentication  # Run tests for test_with_authentication

```


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/tilljoel/bs/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

