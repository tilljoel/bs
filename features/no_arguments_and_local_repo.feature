Feature: uses local git configuration to find remote url
  In a order to understand the current build status without typing to much
  As a user who has a local github repo cloned and build status is reported to github
  I should be able to just type 'bs' or 'build-status'

  Scenario: Run in a local repo with no arguments
    Given the local repo has owner="ruby", repo="ruby"
    When I run `bs --ref=ef18728433d0418b2e002eb46f7abc321ff2d535 --reporter=default_no_color` with vcr
    Then the fetching status should have owner="ruby", repo="ruby" and ref="ef18728433d0418b2e002eb46f7abc321ff2d535"
