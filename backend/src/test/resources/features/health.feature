Feature: Health Check
  As an API consumer
  I want to verify the API is running
  So that I know the service is available

  Scenario: Ping endpoint returns pong
    Given the API is running
    When I send a GET request to "/api/v1/ping"
    Then the response status should be 200
    And the response should contain "pong"
