# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Environment Setup

This is a B2B monorepo with Ruby on Rails backend managed by MISE. The project uses Rails 8.0.2 with Ruby 3.4.5 and PostgreSQL 16.

### Ruby Version Management
- Uses **MISE** (not rbenv) for Ruby version management
- Ruby 3.4.5 is specified in `backend/.ruby-version` 
- MISE automatically activates the correct Ruby version when entering the backend directory
- If Ruby version issues occur, ensure MISE is properly configured: `mise settings add idiomatic_version_file_enable_tools ruby`

### Database Architecture
- **PostgreSQL 16** runs in Docker container via `docker-compose.yml`
- **Solid adapters** for cache, queue, and cable (no Redis dependency)
- Database configs in `backend/config/database.yml` use hardcoded credentials for development
- Production config still references SQLite (needs updating for production deployment)

## Common Development Commands

### Starting Services
```bash
# Start PostgreSQL (from repo root)
docker-compose up -d

# Start Rails server (from backend/)
cd backend
rails server
```

### Database Operations
```bash
cd backend
rails db:create          # Create databases
rails db:migrate         # Run migrations
rails db:reset           # Drop, create, and migrate
rails tmp:clear          # Clear Rails cache
```

### Testing and Quality
```bash
cd backend
bundle exec rspec        # Run tests (if RSpec is added)
bundle exec rubocop     # Run linter
bundle exec brakeman    # Security analysis
```

### Dependency Management
```bash
cd backend
bundle install          # Install gems
bundle update           # Update gems
```

## Architecture Overview

### Monorepo Structure
```
b2b-monorepo/
├── docker-compose.yml   # PostgreSQL service only
├── backend/             # Rails 8 application
└── README.md           # Setup instructions
```

### Rails Application Structure
- **Standard Rails 8 setup** with Solid adapters replacing Redis
- **Health check endpoint** at `/health` with database connectivity verification
- **PostgreSQL integration** for all persistence needs
- **Dockerized development** environment for external services

### Key Architectural Decisions
1. **MISE over rbenv**: Project uses MISE for Ruby version management
2. **Solid over Redis**: Uses Rails 8's solid_cache, solid_queue, solid_cable instead of Redis
3. **PostgreSQL-first**: All data persistence goes through PostgreSQL
4. **Monorepo structure**: Backend is subdirectory, allowing for future frontend additions

### Health Monitoring
- Custom health endpoint at `GET /health` returns detailed JSON status
- Includes database connectivity check via `SELECT 1` query
- Returns appropriate HTTP status codes (200 for healthy, 503 for unhealthy)
- Structured response includes service info, timestamp, and individual check results

## Development Workflow

### Starting Development
1. Ensure Docker is running and start PostgreSQL: `docker-compose up -d`
2. Navigate to backend: `cd backend` (MISE will auto-activate Ruby 3.4.5)
3. Install dependencies: `bundle install`
4. Setup database: `rails db:create db:migrate`
5. Start server: `rails server`

### Adding New Features
- Controllers go in `backend/app/controllers/`
- Models use PostgreSQL via ActiveRecord
- Routes defined in `backend/config/routes.rb`
- Database changes via `rails generate migration`

### Common Issues
- **Ruby version errors**: Ensure MISE is activated and configured
- **Database connection errors**: Verify PostgreSQL container is running
- **Port conflicts**: Rails runs on 3000, PostgreSQL on 5432
- **Bundler version conflicts**: Remove Gemfile.lock and re-run bundle install

## Testing Strategy

The project includes test setup with:
- **Rails testing framework** (standard)
- **Capybara + Selenium** for system tests
- **Debug gem** for development debugging
- **Brakeman** for security analysis
- **RuboCop** for code style (Rails Omakase config)

## Deployment Considerations

- **Kamal** gem included for containerized deployment
- **Thruster** gem for production HTTP optimization
- Production database configuration needs updating (currently references SQLite)
- Health check endpoint suitable for load balancer monitoring

## Development commands in backend

To run lint with rubocop:
```bash
cd backend
rubocop
```

## Tasks

We manage the tasks uslig linear, you can use the linear mcp server to get information of the finished tasks and the pending tasks.

We are using github to manage the repository.
