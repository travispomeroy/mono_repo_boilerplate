package com.polyrepo.domain.b.api;

import java.util.List;

public interface DomainBApi {

  List<String> getItems();

  String getItem(String id);
}
