package com.polyrepo.shared.feature;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class InMemoryFeatureFlagService implements FeatureFlagService {

  private static final Logger log = LoggerFactory.getLogger(InMemoryFeatureFlagService.class);

  private final Map<String, Object> flags = new ConcurrentHashMap<>();

  public InMemoryFeatureFlagService() {
    initializeDefaultFlags();
  }

  private void initializeDefaultFlags() {
    flags.put("feature.example.enabled", true);
  }

  public void setFlag(String flagName, Object value) {
    flags.put(flagName, value);
    log.debug("Feature flag '{}' set to '{}'", flagName, value);
  }

  public void removeFlag(String flagName) {
    flags.remove(flagName);
    log.debug("Feature flag '{}' removed", flagName);
  }

  @Override
  public boolean isEnabled(String flagName) {
    return isEnabled(flagName, null);
  }

  @Override
  public boolean isEnabled(String flagName, String userId) {
    Object value = flags.get(flagName);
    if (value instanceof Boolean boolValue) {
      return boolValue;
    }
    return false;
  }

  @Override
  @SuppressWarnings("unchecked")
  public <T> T getValue(String flagName, T defaultValue) {
    return getValue(flagName, null, defaultValue);
  }

  @Override
  @SuppressWarnings("unchecked")
  public <T> T getValue(String flagName, String userId, T defaultValue) {
    Object value = flags.get(flagName);
    if (value == null) {
      return defaultValue;
    }
    try {
      return (T) value;
    } catch (ClassCastException e) {
      log.warn(
          "Feature flag '{}' value cannot be cast to expected type, returning default", flagName);
      return defaultValue;
    }
  }
}
