Feature: The version should show up in the banner
  As a developer who uses this gem from the command line
  In order to report a bug, update the gem or google for reports
  I should be able to have the current gem version in the banner

  Scenario: Show the bs gem version
    When I run `bs --version `
    Then the banner should include the version
