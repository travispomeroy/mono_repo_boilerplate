package com.polyrepo.steps;

import static org.assertj.core.api.Assertions.assertThat;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

public class HealthSteps {

  @Autowired
  private TestRestTemplate restTemplate;

  private ResponseEntity<String> response;

  @Given("the API is running")
  public void theApiIsRunning() {
    // The API is running by virtue of SpringBootTest
  }

  @When("I send a GET request to {string}")
  public void iSendAGetRequestTo(String path) {
    HttpHeaders headers = new HttpHeaders();
    headers.setBearerAuth("test-token");
    HttpEntity<String> entity = new HttpEntity<>(headers);
    response = restTemplate.exchange(path, HttpMethod.GET, entity, String.class);
  }

  @Then("the response status should be {int}")
  public void theResponseStatusShouldBe(int statusCode) {
    assertThat(response.getStatusCode().value()).isEqualTo(statusCode);
  }

  @And("the response should contain {string}")
  public void theResponseShouldContain(String expected) {
    assertThat(response.getBody()).contains(expected);
  }
}
