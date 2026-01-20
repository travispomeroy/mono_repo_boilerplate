package com.polyrepo.domain.a.service;

import com.polyrepo.domain.a.api.DomainAApi;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DomainAService implements DomainAApi {

  @Override
  public List<String> getItems() {
    return List.of("item-a-1", "item-a-2", "item-a-3");
  }

  @Override
  public String getItem(String id) {
    return "Item A: " + id;
  }
}
