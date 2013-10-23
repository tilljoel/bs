#@announce
Feature: show build status
  In order to understand the current build status for a github repository identified by owner, repo and a ref
  As a user who has a CI-server that create github statuses for each build
  I want a correct build status displayed when running bs

  Scenario: specified ref has build error state
    When I run `bs --ref=77b885264bda990e13fe385199f31c90e0ae668a --repo=ruby --owner=ruby` with vcr
    Then it should pass with:
      """
      ruby/ruby @ 77b885 - error\n
      """

  Scenario: specified ref has build failure state
    When I run `bs --ref=469d4b9389cc2f877f2f17ba248146831d69c66b --repo=ruby --owner=ruby` with vcr
    Then it should pass with:
      """
      ruby/ruby @ 469d4b - failure\n
      """

  Scenario: specified ref has build success state
    When I run `bs --ref=790bfbf55cfa276bec8fb3465440dc4b26004026 --repo=ruby --owner=ruby` with vcr
    Then it should pass with:
      """
      ruby/ruby @ 790bfb - success\n
      """

  Scenario: specified ref has not stauts set
    When I run `bs --ref=8a3856dc1ee0f0a9105592de9b29507eba1a8dda --repo=ruby --owner=ruby` with vcr
    Then it should pass with:
      """
      ruby/ruby @ 8a3856 - no status set\n
      """

  Scenario: specified ref is not found
    When I run `bs --ref=535d808787b65427e763e43bfb768e48df68423e --repo=notfound --owner=popgiro` with vcr
    Then it should fail with:
      """
      popgiro/notfound @ 535d80 - request error
      """

  Scenario: owner,repo and ref not specified
    Given no local repo is found
    When I run `bs` with vcr
    Then it should fail with:
      """
      error: run in a repo with github remote, or set --owner, --repo & --ref
      """
