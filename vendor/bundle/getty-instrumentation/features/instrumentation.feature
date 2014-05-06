Feature: Instrumentation
  As a ruby application
  I want events and logging to work correctly

  @Unisporkal.Instrumentation.Model
  Scenario: Logging scrubs password fields
    Given a log event
    And password fields are present
    When it is written to the log
    Then all password data should be sanitized
    And nonsensitive data is unaffected

  @Unisporkal.Instrumentation.Model
  Scenario: Logging scrubs token fields
    Given a log event
    And token fields are present
    When it is written to the log
    Then all token data should be sanitized
    And nonsensitive data is unaffected

  @Unisporkal.Instrumentation.Model
  Scenario: Logging scrubs credit card fields
    Given a log event
    And credit card fields are present
    When it is written to the log
    Then all credit card numbers should be sanitized
    And nonsensitive data is unaffected

  @Unisporkal.Instrumentation.Model
  Scenario: Logging scrubs CVV fields
    Given a log event
    And CVV fields are present
    When it is written to the log
    Then all CVV numbers should be sanitized
    And nonsensitive data is unaffected
