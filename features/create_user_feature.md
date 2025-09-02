# Create User Feature

## Feature Description

This feature allows a system administrator to create a user and activate them by sending password instructions. The process includes automatic email generation with instructions for the user to set their initial password.

### Business Context

The client has implemented a controlled access model for their B2B service. Rather than providing open registration, they want to grant access only to business partners who meet specific business requirements and criteria.

This manual activation process ensures that every user has been reviewed and approved by the administration team before gaining access to the B2B platform.

## Users Involved

### Admin User
- **Role**: System administrator
- **Responsibilities**: 
  - Access the ActiveAdmin administration panel
  - Navigate to the Users section
  - Send password instructions to existing users
  - Verify that instructions have been sent successfully

### User (John Doe)
- **Role**: System user
- **Responsibilities**:
  - Receive email with password instructions
  - Generate a new password following the email link
  - Authenticate in the system via API
  - Use credentials to access protected services

## Feature Objectives

1. **Facilitate user activation**: Allow administrators to activate existing users by sending password instructions
2. **Automate onboarding process**: Generate automatic emails that guide the user through the password setup process
3. **Validate API authentication**: Ensure that once the password is set, the user can authenticate correctly via API endpoints
4. **Provide visual feedback**: Show visual confirmations in the administration panel about the status of instruction sending

## Technical Flow

### Backend Components Involved
- **ActiveAdmin**: Administration panel for user management
- **Devise**: Authentication system and password management
- **ActionMailer**: Email sending
- **Letter Opener**: Email simulation in development
- **Devise Token Auth**: Token-based authentication API

### Main Models
- **AdminUser**: Administrator user with panel access
- **User**: User who will receive instructions
- **BusinessPartner**: Business partner entity associated with the user

## Acceptance Tests

### Prerequisites
- Rails server must be running on `http://localhost:3000`
- Database must be migrated with test data (seeds)
- Letter Opener email system must be configured
- An AdminUser must exist with credentials:
  - Email: admin@example.com
  - Password: password
- A User "John Doe" must exist in the system

### Scenario 1: Admin sends password instructions

**Steps:**
1. **Login as Admin**
   - Navigate to `http://localhost:3000/admin/login`
   - Enter credentials:
     - User: admin@example.com
     - Password: password
   - Click "Log in"
   - **Expected result**: Successful login, redirect to administration dashboard

2. **Navigate to Users**
   - Click on "Users" in the ActiveAdmin side menu
   - **Expected result**: Users list is displayed

3. **Select John Doe**
   - Locate and click on user "John Doe" in the list
   - **Expected result**: John Doe user detail page opens

4. **Send password instructions**
   - Click on "Resend Password Instructions" button
   - Accept the alert/confirmation that appears
   - **Expected result**: 
     - Confirmation message appears "Reset Password Sent At has been updated"
     - "Reset Password Sent At" field shows current date and time
     - An email is sent

5. **Admin logout**
   - Click on user menu (top right corner)
   - Select "Logout"
   - **Expected result**: Successful logout, redirect to login page

### Scenario 2: User receives and processes instructions

**Steps:**
1. **Verify sent email**
   - Navigate to `http://localhost:3000/letter_opener`
   - Locate the last sent email message
   - **Expected result**: 
     - An email addressed to John Doe exists
     - The email contains instructions to generate password
     - Email texts are correct and professional

2. **Generate new password**
   - Click on "Generate my password" link in the email
   - **Expected result**: Redirect to password setup page

3. **Set password**
   - In the new password form, enter: `password123`
   - Confirm password: `password123`
   - Click "Set password" or equivalent button
   - **Expected result**: 
     - Confirmation message that password was set successfully
     - User becomes activated in the system

### Scenario 3: API authentication validation

**Steps:**
1. **API login test**
   - Execute the following curl command:
   ```bash
   curl -X POST http://localhost:3000/auth/sign_in \
     -H "Content-Type: application/json" \
     -d '{"email": "john.doe@acme.com", "password": "password123"}' \
     -v
   ```
   - **Expected result**:
     - HTTP 200 OK response
     - Headers include: `access-token`, `client`, `uid`
     - Body contains user data (name, surname, customer_id, etc.)

2. **Token validation test**
   - Use tokens obtained in previous step:
   ```bash
   curl -X GET http://localhost:3000/auth/validate_token \
     -H "access-token: [ACCESS_TOKEN_FROM_PREVIOUS_STEP]" \
     -H "client: [CLIENT_TOKEN_FROM_PREVIOUS_STEP]" \
     -H "uid: john.doe@acme.com" \
     -v
   ```
   - **Expected result**:
     - HTTP 200 OK response
     - Confirmation that tokens are valid
     - User data in response

3. **Logout test**
   - Execute logout with valid tokens:
   ```bash
   curl -X DELETE http://localhost:3000/auth/sign_out \
     -H "access-token: [ACCESS_TOKEN]" \
     -H "client: [CLIENT_TOKEN]" \
     -H "uid: john.doe@acme.com" \
     -v
   ```
   - **Expected result**:
     - HTTP 200 OK response
     - Successful logout confirmation
     - Tokens become invalidated

### Reference Commands for QA

#### API Login
```bash
curl -X POST http://localhost:3000/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{"email": "john.doe@acme.com", "password": "password123"}' \
  -v
```

#### Token Validation
```bash
curl -X GET http://localhost:3000/auth/validate_token \
  -H "access-token: [YOUR_ACCESS_TOKEN]" \
  -H "client: [YOUR_CLIENT_TOKEN]" \
  -H "uid: john.doe@acme.com" \
  -v
```

#### Logout
```bash
curl -X DELETE http://localhost:3000/auth/sign_out \
  -H "access-token: [YOUR_ACCESS_TOKEN]" \
  -H "client: [YOUR_CLIENT_TOKEN]" \
  -H "uid: john.doe@acme.com" \
  -v
```

## Success Criteria

### Functional
- ✅ Administrator can send password instructions from ActiveAdmin
- ✅ Email with instructions is correctly generated and sent
- ✅ User can set their password via the email link
- ✅ User can successfully authenticate via API after setting password
- ✅ Authentication tokens work correctly (login, validate, logout)

### Non-Functional
- ✅ Email texts are professional and clear
- ✅ Administration interface provides adequate visual feedback
- ✅ The complete process is intuitive for both user types
- ✅ Error/success messages are informative and appropriate

### Security
- ✅ Passwords are stored securely (encrypted)
- ✅ Authentication tokens rotate correctly
- ✅ Password setup links have expiration
- ✅ Sensitive information is not exposed in logs or responses

## Technical Notes

### Email in Development
- Letter Opener gem is used to simulate email sending
- Emails can be viewed at `http://localhost:3000/letter_opener`
- No real emails are sent during development

### Devise Token Auth
- Uses rotating tokens for enhanced security
- Tokens refresh on each successful request
- Requires 3 headers: `access-token`, `client`, `uid`
- Authentication is stateless and suitable for SPAs

### ActiveAdmin
- Administration interface integrated with Devise
- Allows visual user management and instruction sending
- Custom buttons for specific actions like "Resend Password Instructions"
