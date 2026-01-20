package com.polyrepo.domain.c.api;

import java.util.List;

public interface DomainCApi {

  List<String> getItems();

  String getItem(String id);
}
