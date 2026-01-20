package com.polyrepo.shared.feature;

public interface FeatureFlagService {

  boolean isEnabled(String flagName);

  boolean isEnabled(String flagName, String userId);

  <T> T getValue(String flagName, T defaultValue);

  <T> T getValue(String flagName, String userId, T defaultValue);
}
