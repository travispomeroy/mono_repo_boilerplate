package com.polyrepo.domain.c.service;

import com.polyrepo.domain.c.api.DomainCApi;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DomainCService implements DomainCApi {

  @Override
  public List<String> getItems() {
    return List.of("item-c-1", "item-c-2", "item-c-3");
  }

  @Override
  public String getItem(String id) {
    return "Item C: " + id;
  }
}
