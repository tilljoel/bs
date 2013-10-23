Feature: The minimal reporter prints only the status, nothing more
  As a someone who uses this gem from a script
  In order to avoid using cut, tr, sed to fetch the actual state
  I should be able to use the minimal reporter and only get the state

  Scenario: Use the minimal reporter and success state
    When I run `bs --reporter=minimal --repo=ruby --owner=ruby --ref=ef18728433d0418b2e002eb46f7abc321ff2d535` with vcr
    Then the output should contain exactly "success\n"

  Scenario: Use the minimal reporter and failure state
    When I run `bs --reporter=minimal --repo=ruby --owner=ruby --ref=469d4b9389cc2f877f2f17ba248146831d69c66b` with vcr
    Then the output should contain exactly "failure\n"

  Scenario: Use the minimal reporter and error state
    When I run `bs --reporter=minimal --repo=ruby --owner=tilljoel --ref=ef18728433d0418b2e002eb46f7abc321ff2d535` with vcr
    Then the output should contain exactly "request error\n"
