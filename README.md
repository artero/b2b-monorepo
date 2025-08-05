# B2B Monorepo

Monorepo for B2B application with Rails backend and dockerized services.

## 📋 Dependencies

### System Requirements
- **macOS** (with Homebrew)
- **Docker** and **Docker Compose**
- **Git**

### Development Tools
- **MISE** - Ruby version manager
- **Ruby 3.4.5** - Managed by MISE
- **Rails 8.0.2** - Web framework
- **Bundler 2.6.9** - Ruby dependency manager

### External Services
- **PostgreSQL 16** - Database (via Docker)

## 🚀 Installation and Setup

### 1. Install MISE
```bash
brew install mise
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc

> Note: If you have rbenv, npx, etc. You can use it but we recomend use only mise.
```

### 2. Install Ruby with MISE
```bash
mise install ruby@3.4.5
mise use -g ruby@3.4.5
```

### 3. Install Rails
```bash
gem install rails
```

### 4. Clone the repository
```bash
git clone <repository-url>
cd b2b-monorepo
```

### 5. Setup services with Docker
```bash
# Start PostgreSQL
docker-compose up -d

# Verify it's running
docker-compose ps
```

### 6. Setup Rails backend
```bash
cd backend

# Install Ruby dependencies
bundle install

# Install JavaScript dependencies
yarn install

# Create and migrate database
rails db:create
rails db:migrate

# Start server with asset compilation
bin/dev
```

## 🏃‍♂️ Development Commands

### Start all services
```bash
# 1. Start PostgreSQL
docker-compose up -d

# 2. Start Rails with asset compilation (in another terminal)
cd backend
bin/dev
```

### Check status
- **Health check**: `curl http://localhost:3000/health`
- **Application**: `http://localhost:3000`
- **PostgreSQL**: `docker-compose logs postgres`

### Stop services
```bash
# Stop Rails and asset compilation: Ctrl+C in terminal

# Stop PostgreSQL
docker-compose down
```

## 📁 Project Structure

```
b2b-monorepo/
├── README.md                 # This file
├── docker-compose.yml        # Services (PostgreSQL)
├── .gitignore               # Git ignored files
└── backend/                 # Rails application
    ├── app/
    │   └── controllers/
    │       └── health_controller.rb  # Health check endpoint
    ├── config/
    │   ├── database.yml     # PostgreSQL configuration
    │   └── routes.rb        # Application routes
    ├── Gemfile              # Ruby dependencies
    └── ...                  # Other Rails files
```

## 🔍 Available Endpoints

### Health Check
- **URL**: `GET /health`
- **Description**: Verifies application and database status
- **Successful response** (200):
```json
{
  "status": "ok",
  "timestamp": "2025-01-02T12:00:00Z",
  "service": "b2b-monorepo-backend",
  "version": "1.0.0",
  "checks": {
    "database": {
      "status": "healthy",
      "message": "Database connection successful"
    },
    "rails": {
      "status": "healthy",
      "message": "Rails application is running",
      "environment": "development"
    }
  }
}
```

## 🛠 Troubleshooting

### Issue: "Ruby version not found"
```bash
# Error: ruby: command not found
```
**Solution:**
1. Verify MISE is installed: `mise --version`
2. Activate MISE in your shell: `source ~/.zshrc`
3. Navigate to project directory (should activate Ruby 3.4.5 automatically)

### Issue: "Bundler version conflict"
```bash
# Error: Could not find 'bundler' (2.6.9) required by your Gemfile.lock
```
**Solution:**
```bash
cd backend
rm Gemfile.lock
bundle install
```

### Issue: "Database connection failed"
```bash
# Error: could not connect to server: Connection refused
```
**Solutions:**
1. Verify PostgreSQL is running:
   ```bash
   docker-compose ps
   docker-compose logs postgres
   ```

2. If not running, restart:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

3. Check configuration in `backend/config/database.yml`

### Issue: "Port already in use"
```bash
# Error: Address already in use - bind(2) for "127.0.0.1" port 3000
```
**Solutions:**
1. Find process using the port:
   ```bash
   lsof -ti:3000
   ```

2. Kill the process:
   ```bash
   kill -9 <PID>
   ```

3. Or use a different port:
   ```bash
   rails server -p 3001
   ```

### Issue: "MISE warnings about idiomatic version files"
```bash
# Warning: Idiomatic version files like .ruby-version are currently enabled by default
```
**Solution:**
```bash
mise settings add idiomatic_version_file_enable_tools ruby
```

### Issue: "Permission denied" in Docker
```bash
# Error: Permission denied while trying to connect to Docker daemon
```
**Solution:**
1. Make sure Docker Desktop is running
2. Restart Docker Desktop if necessary

### Quick system verification
```bash
# Check all dependencies
mise --version
ruby --version
rails --version
docker --version
docker-compose --version

# Service status
docker-compose ps
curl -s http://localhost:3000/health | jq '.status'
```

## 📝 Additional Notes

- **Ruby version**: Controlled by `.ruby-version` in the `backend/` directory
- **Database**: PostgreSQL runs on port 5432 (only accessible from localhost)
- **Logs**: Located in `backend/log/development.log`
- **Cache**: Cleared automatically, but you can force with `rails tmp:clear`

For more information about Rails 8, check the [official documentation](https://guides.rubyonrails.org/).
