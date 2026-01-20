# 2. Use Spring Modulith for Backend Architecture

Date: 2026-01-17

## Status

Accepted

## Context

We are building a new backend application that needs to:
- Support multiple bounded contexts (domains)
- Enable independent development of different domains
- Provide a path to microservices if needed in the future
- Maintain clear boundaries between modules
- Support event-driven communication between modules

Traditional monolithic architectures often become hard to maintain as they grow, with unclear boundaries and dependencies. Full microservices add operational complexity that may not be justified for an MVP.

## Decision

We will use Spring Modulith to structure the backend application as a modular monolith.

Key aspects:
- Each domain (A, B, C) is a separate module with defined boundaries
- BFF (Backend for Frontend) module handles external API concerns
- Shared module contains cross-cutting concerns and domain events
- Module dependencies are explicitly declared in `package-info.java`
- Architecture tests verify module boundaries are respected
- Event-driven communication is used between modules

## Consequences

**Positive:**
- Clear module boundaries enforced by Spring Modulith
- Architecture tests catch boundary violations early
- Event-based inter-module communication enables loose coupling
- Path to microservices extraction if needed (modules can become services)
- Simplified deployment and operations compared to microservices
- Single transaction boundary when needed

**Negative:**
- Single deployment unit (can't scale modules independently)
- All modules must use same technology stack
- Requires discipline to maintain module boundaries
- Learning curve for team members unfamiliar with Spring Modulith
