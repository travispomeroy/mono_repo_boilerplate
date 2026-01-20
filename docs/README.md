# Documentation

This directory contains project documentation.

## Contents

### Architecture Decision Records (ADR)

See [adr/](adr/) for architecture decisions.

| ADR | Title | Status |
|-----|-------|--------|
| [0001](adr/0001-record-architecture-decisions.md) | Record Architecture Decisions | Accepted |
| [0002](adr/0002-use-spring-modulith.md) | Use Spring Modulith for Backend Architecture | Accepted |
| [0003](adr/0003-mongodb-for-persistence.md) | Use MongoDB for Persistence | Accepted |
| [0004](adr/0004-okta-for-authentication.md) | Use Okta for Authentication | Accepted |

### Adding a New ADR

1. Copy `adr/template.md` to a new file: `adr/XXXX-title-of-decision.md`
2. Fill in the template with the decision details
3. Update this README with the new ADR
4. Submit a merge request for review
