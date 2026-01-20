package com.polyrepo.domain.b.service;

import com.polyrepo.domain.b.api.DomainBApi;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DomainBService implements DomainBApi {

  @Override
  public List<String> getItems() {
    return List.of("item-b-1", "item-b-2", "item-b-3");
  }

  @Override
  public String getItem(String id) {
    return "Item B: " + id;
  }
}
