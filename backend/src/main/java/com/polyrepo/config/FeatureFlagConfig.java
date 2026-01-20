package com.polyrepo.config;

import com.polyrepo.shared.feature.FeatureFlagService;
import com.polyrepo.shared.feature.InMemoryFeatureFlagService;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnProperty(name = "polyrepo.feature-flags.enabled", havingValue = "true")
public class FeatureFlagConfig {

  @Bean
  @ConditionalOnMissingBean(FeatureFlagService.class)
  public FeatureFlagService featureFlagService() {
    return new InMemoryFeatureFlagService();
  }
}
