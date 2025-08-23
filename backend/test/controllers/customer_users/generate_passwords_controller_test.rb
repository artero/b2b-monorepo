require "test_helper"

class CustomerUsers::GeneratePasswordsControllerTest < ActionController::TestCase
  test "should redirect with error for expired token" do
    user = customer_users(:two)
    user.send_password_generation_instructions
    
    # Create a raw token for testing
    raw_token = Devise.friendly_token
    hashed_token = Devise.token_generator.digest(CustomerUser, :reset_password_token, raw_token)
    
    # Set expired timestamp (25 hours ago)
    user.update_columns(
      reset_password_token: hashed_token,
      reset_password_sent_at: 25.hours.ago
    )
    
    get :edit, params: { reset_password_token: raw_token }
    
    assert_redirected_to generate_passwords_path
    assert_match "ha expirado", flash[:alert]
  end

  test "should allow access with valid token within 24 hours" do
    user = customer_users(:two)
    user.send_password_generation_instructions
    
    # Create a raw token for testing
    raw_token = Devise.friendly_token
    hashed_token = Devise.token_generator.digest(CustomerUser, :reset_password_token, raw_token)
    
    # Set valid timestamp (23 hours ago)
    user.update_columns(
      reset_password_token: hashed_token,
      reset_password_sent_at: 23.hours.ago
    )
    
    get :edit, params: { reset_password_token: raw_token }
    
    assert_response :success
    assert_nil flash[:alert]
  end
end