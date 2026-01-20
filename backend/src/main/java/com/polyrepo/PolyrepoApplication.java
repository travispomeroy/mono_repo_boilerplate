package com.polyrepo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.modulith.Modulithic;

@SpringBootApplication
@Modulithic(
    systemName = "Polyrepo",
    sharedModules = {"shared"})
public class PolyrepoApplication {

  public static void main(String[] args) {
    SpringApplication.run(PolyrepoApplication.class, args);
  }
}
