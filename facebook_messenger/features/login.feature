# language: en
Feature: Login

  Background: User is on FB Messenger Login Screen
    Given that i am on login screen

  Scenario: Login with valid user
    When i fill the email and password field with valid credentials
    And i click on continue button
    And i ignore upload info about my contacts
    And i ignore info about my phone number
    Then i should be redirect for messenger inicial screen

  @reinstall
  Scenario:Login with invalid users
    When i fill the email and password field with invalid credentials
    And i click on continue button
    Then i should see the follow messange "Please enter the email or phone number and password you use to log into Facebook."
