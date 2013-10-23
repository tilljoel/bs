Feature: The help should be printed
  As a developer who uses this gem from the command line
  In order understand how to use the gem
  I should be able print the help

  Scenario: Show the gem help and version
    When I run `bs --help`
    Then the banner should include the version
    Then the banner should include usage
