@org.springframework.modulith.ApplicationModule(
    displayName = "BFF Module",
    allowedDependencies = {"domain::a", "domain::b", "domain::c", "shared"})
@org.springframework.lang.NonNullApi
package com.polyrepo.bff;
