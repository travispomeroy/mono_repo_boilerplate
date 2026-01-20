# 3. Use MongoDB for Persistence

Date: 2026-01-17

## Status

Accepted

## Context

We need a database for the application that:
- Supports flexible, evolving schemas for rapid development
- Handles document-like data structures common in our domain
- Scales horizontally for future growth
- Has good support in the Spring ecosystem
- Can be easily run locally for development
- Has managed cloud offerings for production

## Decision

We will use MongoDB as our primary database, with MongoDB Atlas for production deployment.

Implementation details:
- Spring Data MongoDB for repository abstraction
- Testcontainers with MongoDB for integration tests
- Local MongoDB via Docker Compose for development
- MongoDB Atlas for staging and production environments

## Consequences

**Positive:**
- Flexible schema allows rapid iteration during MVP
- Document model fits well with aggregate-based domain design
- Excellent Spring Data support with repository pattern
- Easy local development with Docker
- MongoDB Atlas provides managed, scalable cloud deployment
- Built-in support for Spring Modulith event externalization

**Negative:**
- No ACID transactions across documents (though rarely needed)
- Team members may need training on MongoDB query patterns
- No foreign key constraints (must enforce in application)
- Need to manage indexes carefully for query performance
