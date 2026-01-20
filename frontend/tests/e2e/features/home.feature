Feature: Home Page
  As a user
  I want to see the home page
  So that I can start using the application

  Scenario: Display home page content
    Given I am on the home page
    Then I should see the welcome message
    And I should see the navigation bar
    And I should see the API status card

  Scenario: Navigate to non-existent page
    Given I am on the home page
    When I navigate to "/non-existent-page"
    Then I should see the 404 page
    And I should see a "Go Home" button
