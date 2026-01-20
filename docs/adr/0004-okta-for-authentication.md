# 4. Use Okta for Authentication

Date: 2026-01-17

## Status

Accepted

## Context

We need an authentication solution that:
- Supports SSO for internal users initially
- Can scale to external users for SaaS offering
- Provides standard OAuth2/OIDC protocols
- Integrates with enterprise identity providers
- Reduces security responsibility on the development team
- Has good Spring Security integration

## Decision

We will use Okta as our identity provider with OAuth2/OIDC for authentication.

Implementation:
- Backend configured as OAuth2 Resource Server validating JWTs
- Frontend uses Okta Auth JS SDK for authentication flow
- Access tokens included in API requests for authorization
- Okta groups mapped to application roles

## Consequences

**Positive:**
- Industry-standard OAuth2/OIDC protocols
- Enterprise SSO integration out of the box
- Reduces security implementation burden
- Excellent Spring Security OAuth2 Resource Server support
- Can add MFA, passwordless, social login via Okta config
- Scales from internal SSO to external SaaS users

**Negative:**
- External dependency on Okta service
- Licensing costs as user base grows
- Requires Okta configuration alongside application code
- Token validation adds latency to requests (mitigated by caching)
- Team needs to understand OAuth2/OIDC concepts
