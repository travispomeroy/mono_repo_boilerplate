package com.polyrepo.domain.a.api;

import java.util.List;

public interface DomainAApi {

  List<String> getItems();

  String getItem(String id);
}
