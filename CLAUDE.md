# CLAUDE.md - Monorepo

This file provides guidance to Claude Code (claude.ai/code) when working with this B2B monorepo at the repository level.

## Monorepo Overview

This is a B2B monorepo with a Ruby on Rails backend. The project structure allows for future additions of frontend applications, microservices, or other components.

### Repository Structure
```
b2b-monorepo/
├── docker-compose.yml   # Infrastructure dependencies: PostgreSQL service
├── backend/             # Rails 8 application (see backend/CLAUDE.md)
├── .github/             # CI/CD workflows
└── README.md           # Setup instructions
```

### Key Architectural Decisions
1. **Monorepo structure**: Centralized codebase with potential for multiple applications
2. **Dockerized services**: External dependencies managed via Docker Compose
3. **Modern tooling**: GitHub Actions for CI/CD, MISE for development environment management

## Infrastructure Services

### PostgreSQL Database
- **PostgreSQL 16** runs in Docker container via `docker-compose.yml`
- Shared database service for all applications in the monorepo
- Development credentials hardcoded in docker-compose for simplicity

### Docker Services Management
```bash
# Start all services
docker-compose up -d

# Check service status
docker-compose ps

# Stop all services
docker-compose down

# View logs
docker-compose logs postgres
```

## Project Management

### Task Management
- **Linear integration**: Use Linear MCP server to track tasks and issues
- Tasks are managed through Linear workspace with proper status tracking
- Use `mcp__linear-server__*` tools to interact with Linear API

#### Linear Task Structure
Every Linear task should follow this structured format for consistency and clarity:

**Description**
Clear, concise explanation of what needs to be accomplished

**Specs de la tarea**
Functional specifications and acceptance criteria

**Descripción técnica**
Technical implementation details, approach, and considerations

**Example: PINTY-50**
```
Configurar la estructura inicial del proyecto, incluyendo la configuración básica y dependencias.

## Specs de la tarea

### 1. Arrancar el proyecto 

Seguir el readme para arrancar el proyecto, ejecutar endpoint /healthy ha de retornar OK.

Test por curl

cd backend && rails s

En otro terminal.

curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health && echo " - OK" || echo " - ERROR"

### 2. Repositorio accesible en Github

Se ha de poder acceder al proyecto privado por Github con un Readme de con la descripción del proyecto.

Repositorio: https://github.com/artero/b2b-monorepo

### Descripción técnica

- Inicialización del proyecto usando MISE (Esta herramienta es como rbenv y npm pero para todos los lenguajes)
- Inicializar proyecto Rails 8 en  b2b/backend (Esctuctura Monorepo)
- Instalación Infra con docker-compose, ultimas versiones de:
- Solo PostgreSQLRails: Configurado para PostgreSQL + Solid adapters
- Ventajas de Solid: Cache, Jobs y Cable en DB sin dependencias externas
- Crear endpoint health que valide que rails, 
- Readme ha de explicar dependencias, y como arrancar el proyecto en desarrollo.
- Commit inicial y push a nuevo repo privado de GitHub b2b-monorepo

```

### Version Control  
- **GitHub repository**: Primary code hosting and collaboration platform
- **GitHub Actions CI/CD**: Automated testing and deployment pipeline at `.github/workflows/ci.yml`
- **Branch strategy**: Feature branches merged to main via pull requests

### CI/CD Pipeline
- **Linting**: RuboCop with parallel execution for code style
- **Security**: Brakeman security analysis
- **Testing**: Rails test suite with PostgreSQL service
- **System tests**: Capybara + Selenium integration tests
- **Database**: PostgreSQL 16 Alpine container with health checks

## Tool Integration

### Available Tools
- **Linear MCP**: Task management and issue tracking via `mcp__linear-server__*` tools
- **GitHub CLI**: Repository operations via `gh` command
- **Docker**: Service management via `docker-compose`
- **MISE**: Development environment management

### Working with Applications
- **Backend Rails app**: See `backend/CLAUDE.md` for Rails-specific guidance
- **Future applications**: Will have their own CLAUDE.md files in respective directories

## Authentication System

### Devise Token Auth Implementation
- **API Authentication**: Implemented with `devise_token_auth` gem for secure stateless authentication
- **Customer User Model**: Integrated with existing CustomerUser model with blocked user support
- **Token-based Security**: Uses rotating tokens that refresh on each request for enhanced security
- **Token Lifespan**: Configurable token expiration (default: 2 weeks)

### API Endpoints
```bash
# Authentication endpoints
POST   /auth/sign_in          # Login - returns tokens in headers
DELETE /auth/sign_out         # Logout - invalidates tokens  
GET    /auth/validate_token   # Validate current tokens
POST   /auth/password         # Password reset functionality
```

### Authentication Flow for Frontend Applications
1. **Login**: POST credentials to `/auth/sign_in`
2. **Token Storage**: Extract `access-token`, `client`, and `uid` from response headers
3. **Request Authentication**: Include all 3 headers in subsequent API requests
4. **Token Refresh**: Update stored tokens from response headers after each successful request
5. **User Access**: Rails automatically provides `@current_customer_user` in protected controllers

### Controller Architecture
- **ApiController**: Base controller for API endpoints with DeviseTokenAuth integration
- **Auth::SessionsController**: Handles login/logout with CSRF protection disabled
- **Auth::TokenValidationsController**: Manages token validation
- **Protected Resources**: Inherit from `ApiController` and use `before_action :authenticate_customer_user!`

### Security Features
- **Blocked User Protection**: Users with `blocked: true` cannot authenticate
- **Token Rotation**: Tokens regenerate on each request preventing replay attacks
- **CSRF Protection**: Disabled for API endpoints, enabled for web interface
- **Separate Concerns**: Authentication logic isolated from main ApplicationController

## Development Workflow

### Repository-Level Operations
1. Start infrastructure services: `docker-compose up -d`
2. Navigate to specific application directory for development
3. Use GitHub CLI for repository-level operations (PRs, issues, etc.)
4. Use Linear tools for task management across the entire project

### API Testing
```bash
# Test login endpoint
curl -X POST http://localhost:3000/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password123"}' \
  -v

# Test protected endpoint with tokens
curl -X GET http://localhost:3000/api/v1/protected-resource \
  -H "access-token: YOUR_ACCESS_TOKEN" \
  -H "client: YOUR_CLIENT_TOKEN" \
  -H "uid: YOUR_USER_EMAIL"
```
