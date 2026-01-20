# Polyrepo

A modern monorepo with React frontend and Spring Boot Modulith backend.

## Technology Stack

| Layer | Technology |
|-------|------------|
| Frontend | React 18, TypeScript, Vite, Redux Toolkit, RTK Query, MUI |
| Backend | Java 21, Spring Boot 3.4, Spring Modulith, Spring Data MongoDB |
| Database | MongoDB |
| Auth | Okta SSO/OIDC |
| Testing | JUnit 5, Testcontainers, Vitest, Playwright, Cucumber |
| CI/CD | GitLab CI |
| Infrastructure | Docker Compose (local), Okteto (preview), EKS (production) |

## Prerequisites

- Java 21+
- Node.js 20+
- Docker and Docker Compose
- Maven 3.9+ (or use included wrapper)

### Verify Your Environment

Run the environment verification script to ensure all prerequisites are installed:

```bash
# Clone the repo first, then run:
npm install
npm run verify

# Or run directly:
./scripts/verify-environment.sh
```

This will check:
- Required tool versions (Java, Node, npm, Docker, Git)
- Optional tools (Okteto CLI, kubectl, AWS CLI)
- Project setup (dependencies, husky hooks)
- Port availability (3000, 8080, 27017)

## Quick Start

### Using Docker Compose (Recommended)

```bash
# Start all services
docker compose -f docker/docker-compose.yml up

# Start with development hot-reload
docker compose -f docker/docker-compose.yml --profile dev up
```

Access the application:
- Frontend: http://localhost:3000
- Backend API: http://localhost:8080
- Swagger UI: http://localhost:8080/swagger-ui.html
- MongoDB Express (dev-tools profile): http://localhost:8081

### Manual Development

**Backend:**
```bash
cd backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=local
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

## Project Structure

```
polyrepo/
├── frontend/                    # React application
├── backend/                     # Spring Boot Modulith application
├── docker/                      # Docker configurations
├── okteto/                      # Okteto preview environment configs
├── docs/                        # Documentation
│   └── adr/                     # Architecture Decision Records
├── okteto.yml                   # Okteto manifest
├── .gitlab-ci.yml               # CI/CD pipeline
└── package.json                 # Root tooling (husky, commitlint)
```

### Backend Module Structure

```
backend/src/main/java/com/polyrepo/
├── PolyrepoApplication.java
├── bff/                         # Backend for Frontend module
│   └── api/v1/                  # REST controllers
├── domain/
│   ├── a/                       # Domain A module
│   ├── b/                       # Domain B module
│   └── c/                       # Domain C module
├── shared/                      # Shared kernel
│   ├── event/                   # Domain events
│   ├── feature/                 # Feature flags
│   └── model/                   # Common models
└── config/                      # Application configuration
```

## Development Workflow

### Commit Convention

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

feat(frontend): add user dashboard
fix(backend): resolve authentication issue
docs: update README
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

### Running Tests

**Backend:**
```bash
cd backend
./mvnw test                      # Unit tests
./mvnw verify                    # Integration tests
./mvnw test -Dtest=ModularityTests  # Architecture tests
```

**Frontend:**
```bash
cd frontend
npm test                         # Unit tests with Vitest
npm run test:coverage            # With coverage
npm run test:e2e                 # E2E tests with Playwright
```

### Code Quality

**Backend:**
```bash
cd backend
./mvnw spotless:check            # Check formatting
./mvnw spotless:apply            # Apply formatting
```

**Frontend:**
```bash
cd frontend
npm run lint                     # ESLint
npm run format:check             # Prettier check
npm run format                   # Apply Prettier
```

## API Documentation

OpenAPI documentation is available at:
- Swagger UI: http://localhost:8080/swagger-ui.html
- OpenAPI JSON: http://localhost:8080/v3/api-docs

Generate TypeScript client:
```bash
cd frontend
npm run generate:api
```

## Architecture Decision Records

See [docs/adr/](docs/adr/) for architecture decisions.

## Environment Variables

### Backend

| Variable | Description | Default |
|----------|-------------|---------|
| SPRING_PROFILES_ACTIVE | Active Spring profile | local |
| MONGODB_URI | MongoDB connection string | mongodb://localhost:27017/polyrepo |
| OKTA_ISSUER_URI | Okta OAuth2 issuer URI | - |
| OKTA_JWK_SET_URI | Okta JWK set URI | - |

### Frontend

| Variable | Description | Default |
|----------|-------------|---------|
| VITE_API_URL | Backend API URL | /api |

## CI/CD Pipeline

The GitLab CI pipeline includes:

1. **validate** - Lint, format check, commitlint
2. **build** - Compile frontend & backend
3. **test** - Unit tests, integration tests, modularity tests, E2E
4. **security** - Dependency scanning, SAST, secrets detection
5. **package** - Build Docker images
6. **deploy-preview** - Deploy to Okteto (on MR)
7. **deploy-prod** - Deploy to EKS (on main merge)

## Okteto Preview Environments

Preview environments are automatically created for each merge request using Okteto.

### Configuration Files

- `okteto.yml` - Main Okteto manifest defining build and deploy configuration
- `okteto/docker-compose.yml` - Compose file for Okteto deployments
- `backend/src/main/resources/application-okteto.yml` - Spring profile for Okteto

### Local Development with Okteto

```bash
# Install Okteto CLI
brew install okteto

# Login to Okteto
okteto context use https://okteto.example.com --token $OKTETO_TOKEN

# Deploy to Okteto
okteto deploy

# Start development mode (with hot reload)
okteto up backend   # For backend development
okteto up frontend  # For frontend development

# Destroy the environment
okteto destroy
```

### Required GitLab CI Variables for Okteto

| Variable | Description |
|----------|-------------|
| OKTETO_URL | Okteto instance URL |
| OKTETO_TOKEN | Okteto API token |
| OKTA_ISSUER_URI | Okta issuer URI for preview environments |
| OKTA_JWK_SET_URI | Okta JWK set URI for preview environments |

Preview environments are accessible at: `https://<mr-id>.polyrepo.okteto.dev`

## License

Proprietary
