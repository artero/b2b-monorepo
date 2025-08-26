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
├── features/                # Feature documentation
│   └── create_customer_user_feature.md  # Create Customer User feature specs
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

## 📋 Features Documentation

This project includes comprehensive feature documentation for QA testing and development reference. Each feature document contains:

- **Feature description and objectives**
- **User roles and responsibilities**
- **Technical implementation details**
- **Step-by-step acceptance tests**
- **API testing commands**
- **Success criteria**

### Available Features

1. **[Create Customer User Feature](features/create_customer_user_feature.md)**
   - Admin can send password instructions to customer users
   - Customer users can set passwords via email links
   - Full API authentication flow validation
   - Integration with ActiveAdmin and Letter Opener

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

### Authentication API
- **URL**: `POST /auth/sign_in`
- **Description**: Customer user login with token-based authentication
- **Request body**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
- **Successful response** (200) - **Tokens returned in headers**:
```json
{
  "data": {
    "email": "user@example.com",
    "provider": "email",
    "uid": "user@example.com",
    "customer_id": 123,
    "id": 456,
    "name": "John",
    "surname": "Doe"
  }
}
```
- **Response Headers** (Important for authentication):
```
access-token: AbCdEf123XyZ...
client: 12345-67890-abcdef...
uid: user@example.com
```

- **URL**: `DELETE /auth/sign_out`
- **Description**: Logout and invalidate tokens
- **Headers required**:
```
access-token: YOUR_ACCESS_TOKEN
client: YOUR_CLIENT_TOKEN
uid: YOUR_USER_EMAIL
```

- **URL**: `GET /auth/validate_token`
- **Description**: Validate current authentication tokens
- **Headers required**: Same as sign_out

## 🔐 Authentication System (Devise Token Auth)

### Overview
This application uses **Devise Token Auth** for secure, stateless API authentication. The system is designed for frontend applications (React, Angular, etc.) that need to authenticate users and make subsequent API requests.

### Key Security Features

#### 🔄 **Token Rotation (High Security)**
- **Tokens refresh on EVERY successful request** - not just login
- This prevents token replay attacks and limits exposure time
- Frontend must update stored tokens after each API call

#### ⏰ **Short Token Lifespan**
- Default token expiration: **2 weeks** (configurable)
- Tokens become invalid after the configured time period
- Automatic cleanup of expired tokens from database

#### 🛡️ **Multi-Token Authentication**
Requires **3 separate tokens** for each request:
- `access-token`: Main authentication token (rotates on each request)
- `client`: Client identifier (rotates with access-token)  
- `uid`: User identifier (user's email address)

#### 🚫 **Blocked User Protection**
- Users with `blocked: true` cannot authenticate
- Automatic rejection at the authentication layer
- No additional checks needed in protected controllers

### Authentication Flow

#### 1. **Initial Login**
```bash
curl -X POST http://localhost:3000/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password123"}'
```

**Response includes tokens in headers:**
```
access-token: AbCdEf123XyZ...
client: 12345-67890-abcdef...
uid: user@example.com
```

#### 2. **Subsequent Requests** 
```bash
curl -X GET http://localhost:3000/api/v1/protected-resource \
  -H "access-token: AbCdEf123XyZ..." \
  -H "client: 12345-67890-abcdef..." \
  -H "uid: user@example.com"
```

**⚠️ Important**: Response headers contain **new tokens** that must be stored!

#### 3. **Frontend Token Management**
```javascript
// Save tokens after login
const saveTokens = (response) => {
  localStorage.setItem('access-token', response.headers.get('access-token'));
  localStorage.setItem('client', response.headers.get('client'));
  localStorage.setItem('uid', response.headers.get('uid'));
};

// Include tokens in every API request
const authenticatedFetch = async (url, options = {}) => {
  const response = await fetch(url, {
    ...options,
    headers: {
      'access-token': localStorage.getItem('access-token'),
      'client': localStorage.getItem('client'),
      'uid': localStorage.getItem('uid'),
      ...options.headers
    }
  });
  
  // CRITICAL: Update tokens after each successful request
  if (response.ok) {
    saveTokens(response);
  }
  
  return response;
};
```

### Why This Security Model?

#### **Traditional vs Token Auth Comparison**

| Feature | Session-based | JWT | Devise Token Auth |
|---------|---------------|-----|-------------------|
| State | Stateful | Stateless | Stateless |
| Security | Server-side sessions | Long-lived tokens | Rotating tokens |
| Scalability | Limited | Excellent | Excellent |
| Mobile/SPA | Poor | Good | Excellent |
| Token Refresh | N/A | Manual | Automatic |
| Replay Attack Protection | Session timeout | Token expiration | Token rotation |

#### **Security Advantages:**
1. **Token Rotation**: Each request generates new tokens, limiting the window for attacks
2. **Multi-token System**: Requires multiple pieces of information to authenticate  
3. **Database Validation**: Tokens are validated against the database on each request
4. **Automatic Cleanup**: Expired tokens are automatically removed
5. **Blocked User Support**: Built-in support for disabling user access

### Testing Authentication

#### **Create Test User**
```bash
# Rails console
rails console

customer = Customer.create!(
  name: "Test Customer",
  code: "test_001", 
  email: "customer@test.com"
)

user = CustomerUser.create!(
  name: "Test",
  surname: "User", 
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123",
  customer: customer,
  blocked: false,
  provider: "email",
  uid: "test@example.com"
)
```

#### **Test with cURL**
```bash
# 1. Login and save tokens
curl -X POST http://localhost:3000/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}' \
  -v

# 2. Copy tokens from response headers and test validation
curl -X GET http://localhost:3000/auth/validate_token \
  -H "access-token: YOUR_ACCESS_TOKEN" \
  -H "client: YOUR_CLIENT_TOKEN" \
  -H "uid: test@example.com" \
  -v
```

### Error Responses

#### **Authentication Failures (401)**
```json
{
  "success": false,
  "errors": ["Invalid login credentials. Please try again."]
}
```

#### **Blocked User (401)**
```json
{
  "success": false, 
  "errors": ["Your account is not activated."]
}
```

#### **Invalid/Expired Tokens (401)**
```json
{
  "errors": ["Invalid token."]
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

### Issue: "Authentication tokens not working"
```bash
# Error: 401 Unauthorized on API requests
```
**Solutions:**
1. **Verify token headers are included** in every request:
   ```bash
   curl -X GET http://localhost:3000/auth/validate_token \
     -H "access-token: YOUR_TOKEN" \
     -H "client: YOUR_CLIENT" \
     -H "uid: YOUR_EMAIL" \
     -v
   ```

2. **Check token expiration** (tokens expire after 2 weeks by default):
   ```bash
   # Login again to get fresh tokens
   curl -X POST http://localhost:3000/auth/sign_in \
     -H "Content-Type: application/json" \
     -d '{"email": "user@example.com", "password": "password123"}'
   ```

3. **Verify user is not blocked**:
   ```bash
   # Rails console
   rails console
   user = CustomerUser.find_by(email: "user@example.com")
   puts user.blocked?  # Should return false
   ```

### Issue: "Tokens keep becoming invalid"
**Cause**: Frontend not updating tokens after each request
**Solution**: Always update stored tokens from response headers:
```javascript
// After each successful API request
if (response.ok) {
  const newToken = response.headers.get('access-token');
  const newClient = response.headers.get('client');
  
  if (newToken && newClient) {
    localStorage.setItem('access-token', newToken);
    localStorage.setItem('client', newClient);
  }
}
```

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

# Test authentication
curl -X POST http://localhost:3000/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}' \
  -v
```

## 📧 Email Development

### Letter Opener
In development, emails are automatically opened in your browser using the `letter_opener` gem instead of being sent to real email addresses.

**Features:**
- All sent emails open automatically in your default browser
- Emails are stored locally in `tmp/letter_opener/`
- No email configuration needed for development
- Works with all Rails mailers (user registration, password reset, etc.)

**Usage:**
1. Trigger any action that sends an email (registration, password reset, etc.)
2. Email will automatically open in your browser
3. View previously sent emails by browsing to `http://localhost:3000/letter_opener` (if available) or check `tmp/letter_opener/` directory


## 📝 Additional Notes

- **Ruby version**: Controlled by `.ruby-version` in the `backend/` directory
- **Database**: PostgreSQL runs on port 5432 (only accessible from localhost)
- **Logs**: Located in `backend/log/development.log`
- **Cache**: Cleared automatically, but you can force with `rails tmp:clear`
- **Emails**: Development emails open in browser via `letter_opener` gem
- **Authentication**: Uses Devise Token Auth with rotating tokens for maximum security
- **API Endpoints**: All authentication endpoints are under `/auth/*`
- **Token Storage**: Frontend must store and update `access-token`, `client`, and `uid` headers
- **Security**: Tokens refresh on every successful request (NOT just login)

### Related Documentation
- **Rails 8**: [Official Rails Guides](https://guides.rubyonrails.org/)
- **Devise**: [Authentication Documentation](https://github.com/heartcombo/devise)  
- **Devise Token Auth**: [API Authentication Guide](https://github.com/lynndylanhurley/devise_token_auth)
- **PostgreSQL**: [Official PostgreSQL Documentation](https://www.postgresql.org/docs/)
