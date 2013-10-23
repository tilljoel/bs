Feature: exit status
  As a developer who uses this gem from a script
  In order take action on the exit status
  I want a correct exit status to act on

  Scenario: failure, exit status of two
    When I run `bs --help`
    Then the exit status should be 2

  Scenario: failure, exit status of one
    When I run `bs --log_level WARN --ref=790bfbf55cfa276bec8fb3465440dc4b26004026 --repo=ruby --owner=ruby` with vcr
    Then it should fail with:
      """
      error: an argument is missing a value
      """

  Scenario: failure, exit status of one
    When I run `bs --invalid --ref=790bfbf55cfa276bec8fb3465440dc4b26004026 --repo=ruby --owner=ruby` with vcr
    Then it should fail with:
      """
      error: unknown argument: invalid
      """

  Scenario: api success, exit status of zero
    When I run `bs --ref=790bfbf55cfa276bec8fb3465440dc4b26004026 --repo=ruby --owner=ruby` with vcr
    Then the exit status should be 0

  #Scenario: Press ctrl-c
    #When I run `bs --ref=790bfbf55cfa276bec8fb3465440dc4b26004026 --repo=ruby --owner=ruby` with vcr interactively
    #And I type ""
    #Then the exit status should be 2

