package com.polyrepo.bff.api.v1;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.time.Instant;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
@Tag(name = "Health", description = "Health check endpoints")
public class HealthController {

  @GetMapping("/ping")
  @Operation(summary = "Simple ping endpoint", description = "Returns pong to verify API is running")
  public ResponseEntity<Map<String, Object>> ping() {
    return ResponseEntity.ok(
        Map.of(
            "status", "ok",
            "message", "pong",
            "timestamp", Instant.now().toString()));
  }
}
