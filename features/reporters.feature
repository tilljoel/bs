Feature: The reporters should yield different output
  As a developer who uses this gem from the command line
  In order to use it for different use-cases I need to change output
  I should be able set reporter using the command flag

  Scenario: The none_reporter shows no output and is useless
    When I run `bs --repo=ruby --owner=ruby --ref=ef18728433d0418b2e002eb46f7abc321ff2d535 --reporter=none` with vcr
    Then the output should contain exactly ""

  Scenario Outline: When buid succeeds, All reporters should print success state at least
    When I run `bs --repo=ruby --owner=ruby --ref=ef18728433d0418b2e002eb46f7abc321ff2d535 --reporter=<flag>` with vcr
    Then the exit status should be 0
    Then the output should contain "success"
    Examples:
      |flag |
      |'minimal' |
      |'default' |
      |'default_no_color'|
      |'full' |

  Scenario Outline: When build errors, all reporters should print error state at least
    When I run `bs --repo=ruby --owner=tilljoel --ref=ef18728433d0418b2e002eb46f7abc321ff2d535 --reporter=<flag>` with vcr
    Then the exit status should be 1
    Then the output should contain "error"
    Examples:
      |flag |
      |'minimal' |
      |'default' |
      |'default_no_color'|
      |'full' |


