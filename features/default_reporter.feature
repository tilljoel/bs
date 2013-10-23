Feature: The default reporter should just work
  As a someone who uses this gem often, the default reporter is a good pick
  In order to see the buildstatus fast, colors are used in the output
  I should see the default reporter if no reporeters are defined

  Scenario: Use the default reporter and success state
    When I run `bs  --owner=ruby --repo=ruby --ref=ef18728433d0418b2e002eb46f7abc321ff2d535` with vcr
    Then the fetching status should have owner="ruby", repo="ruby" and ref="ef18728433d0418b2e002eb46f7abc321ff2d535"
    Then the output should contain "ruby/ruby @ ef1872 - success\n"

  Scenario: Use the default reporter and failure state
    When I run `bs --owner=ruby --repo=ruby --ref=469d4b9389cc2f877f2f17ba248146831d69c66b` with vcr
    Then the fetching status should have owner="ruby", repo="ruby" and ref="469d4b9389cc2f877f2f17ba248146831d69c66b"
    Then the output should contain "ruby/ruby @ 469d4b - failure\n"

  Scenario: Use the default reporter and error state
    When I run `bs --owner=tilljoel --repo=ruby --ref=ef18728433d0418b2e002eb46f7abc321ff2d535` with vcr
    Then the fetching status should have owner="tilljoel", repo="ruby" and ref="ef18728433d0418b2e002eb46f7abc321ff2d535"
    Then the output should contain "tilljoel/ruby @ ef1872 - request error"

