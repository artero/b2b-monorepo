require 'test_helper'

class AuthTest < ActionDispatch::IntegrationTest
  def setup
    @active_user = customer_users(:one)
    @active_user.update!(
      password: "password123",
      password_confirmation: "password123"
    )
    
    @blocked_user = customer_users(:two)
    @blocked_user.update!(
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "successful login returns auth tokens" do
    post "/auth/sign_in", params: {
      email: @active_user.email,
      password: "password123"
    }
    
    assert_response :ok
    
    # Check that auth headers are present
    assert response.headers['access-token'].present?
    assert response.headers['client'].present?
    assert response.headers['uid'].present?
    assert_equal @active_user.email, response.headers['uid']
    
    # Check response body contains user data
    json_response = JSON.parse(response.body)
    assert json_response['data']
    assert_equal @active_user.email, json_response['data']['email']
    assert_equal @active_user.name, json_response['data']['name']
    assert_equal @active_user.surname, json_response['data']['surname']
  end

  test "login with non-existent user returns unauthorized" do
    post "/auth/sign_in", params: {
      email: "nonexistent@example.com",
      password: "password123"
    }
    
    assert_response :unauthorized
    
    # Check that no auth headers are present
    assert response.headers['access-token'].blank?
    assert response.headers['client'].blank?
    assert response.headers['uid'].blank?
    
    # Check error message
    json_response = JSON.parse(response.body)
    assert json_response['errors'].present?
  end

  test "login with blocked user returns unauthorized" do
    post "/auth/sign_in", params: {
      email: @blocked_user.email,
      password: "password123"
    }
    
    assert_response :unauthorized
    
    # Check that no auth headers are present
    assert response.headers['access-token'].blank?
    assert response.headers['client'].blank?
    assert response.headers['uid'].blank?
  end

  test "login with incorrect email returns unauthorized" do
    post "/auth/sign_in", params: {
      email: "wrong@example.com",
      password: "password123"
    }
    
    assert_response :unauthorized
    
    # Check that no auth headers are present
    assert response.headers['access-token'].blank?
    assert response.headers['client'].blank?
    assert response.headers['uid'].blank?
  end

  test "login with incorrect password returns unauthorized" do
    post "/auth/sign_in", params: {
      email: @active_user.email,
      password: "wrongpassword"
    }
    
    assert_response :unauthorized
    
    # Check that no auth headers are present
    assert response.headers['access-token'].blank?
    assert response.headers['client'].blank?
    assert response.headers['uid'].blank?
  end

  test "successful logout with valid tokens" do
    # First login to get tokens
    post "/auth/sign_in", params: {
      email: @active_user.email,
      password: "password123"
    }
    
    assert_response :ok
    
    # Extract tokens from login response
    access_token = response.headers['access-token']
    client = response.headers['client']
    uid = response.headers['uid']
    
    # Now logout
    delete "/auth/sign_out", headers: {
      'access-token' => access_token,
      'client' => client,
      'uid' => uid
    }
    
    assert_response :ok
  end

  test "logout without tokens returns unauthorized" do
    delete "/auth/sign_out"
    
    assert_response :not_found
  end

  test "validate token with valid tokens returns success" do
    # First login to get tokens
    post "/auth/sign_in", params: {
      email: @active_user.email,
      password: "password123"
    }
    
    assert_response :ok
    
    # Extract tokens from login response
    access_token = response.headers['access-token']
    client = response.headers['client']
    uid = response.headers['uid']
    
    # Validate token
    get "/auth/validate_token", headers: {
      'access-token' => access_token,
      'client' => client,
      'uid' => uid
    }
    
    assert_response :ok
    
    json_response = JSON.parse(response.body)
    assert json_response['success'] == true
    assert json_response['data']
    assert_equal @active_user.email, json_response['data']['email']
  end

  test "validate token with invalid tokens returns unauthorized" do
    get "/auth/validate_token", headers: {
      'access-token' => 'invalid',
      'client' => 'invalid',
      'uid' => 'invalid@example.com'
    }
    
    assert_response :unauthorized
  end
end
