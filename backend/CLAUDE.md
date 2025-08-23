# CLAUDE.md - Rails Backend

This file provides guidance to Claude Code (claude.ai/code) when working specifically with the Rails backend application.

## Development Environment Setup

This Rails 8.0.2 application uses Ruby 3.4.5 managed by MISE and PostgreSQL 16 for data persistence.

### Ruby Version Management
- Uses **MISE** (not rbenv) for Ruby version management
- Ruby 3.4.5 is specified in `.ruby-version` 
- MISE automatically activates the correct Ruby version when entering this directory
- If Ruby version issues occur, ensure MISE is properly configured: `mise settings add idiomatic_version_file_enable_tools ruby`

### Database Architecture
- **PostgreSQL 16** runs in Docker container via `../docker-compose.yml`
- **Solid adapters** for cache, queue, and cable (no Redis dependency)
- Database configs in `config/database.yml` use hardcoded credentials for development
- Production config still references SQLite (needs updating for production deployment)

## Common Development Commands

### Starting Services
```bash
# Start PostgreSQL (from repo root)
cd .. && docker-compose up -d

# Start Rails server with asset compilation
bin/dev
```

### Database Operations
```bash
rails db:create          # Create databases
rails db:migrate         # Run migrations
rails db:reset           # Drop, create, and migrate
rails tmp:clear          # Clear Rails cache
```

### Testing and Quality
```bash
rails test              # Run tests
rubocop                 # Run linter
brakeman                # Security analysis
```

### Dependency Management
```bash
bundle install          # Install Ruby gems
yarn install            # Install JavaScript dependencies
bundle update           # Update gems
```

## Rails Application Structure
- **Standard Rails 8 setup** with Solid adapters replacing Redis
- **Health check endpoint** at `/health` with database connectivity verification
- **PostgreSQL integration** for all persistence needs
- **Customer User Authentication** with Devise and secure password generation workflow
- **ActiveAdmin panel** for backend administration

### Key Architectural Decisions
1. **MISE over rbenv**: Project uses MISE for Ruby version management
2. **Solid over Redis**: Uses Rails 8's solid_cache, solid_queue, solid_cable instead of Redis
3. **PostgreSQL-first**: All data persistence goes through PostgreSQL

### Health Monitoring
- Custom health endpoint at `GET /health` returns detailed JSON status
- Includes database connectivity check via `SELECT 1` query
- Returns appropriate HTTP status codes (200 for healthy, 503 for unhealthy)
- Structured response includes service info, timestamp, and individual check results

## Development Workflow

### Starting Development
1. Ensure Docker is running and start PostgreSQL: `cd .. && docker-compose up -d`
2. Install dependencies: `bundle install && yarn install`
3. Setup database: `rails db:create db:migrate`
4. Start server with asset compilation: `bin/dev`

### Adding New Features
- Controllers go in `app/controllers/`
- Models use PostgreSQL via ActiveRecord
- Routes defined in `config/routes.rb`
- Database changes via `rails generate migration`

### Customer User Password Generation
- **Controller**: `CustomerUsers::GeneratePasswordsController`
- **Routes**: Namespaced under `/customer_users/generate_passwords`
- **Token-based security**: Uses Devise's reset password token mechanism
- **Database tracking**: Includes `generated_password_at` timestamp
- **Token expiration**: 7 days from `reset_password_sent_at`
- **Flash messaging**: Success/error feedback with redirect patterns

### Common Issues
- **Ruby version errors**: Ensure MISE is activated and configured
- **Database connection errors**: Verify PostgreSQL container is running via `cd .. && docker-compose ps`
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

