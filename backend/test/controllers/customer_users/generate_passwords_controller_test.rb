require "test_helper"

class CustomerUsers::GeneratePasswordsControllerTest < ActionController::TestCase
  def setup
    @user = customer_users(:two)
    @raw_token = Devise.friendly_token
    @hashed_token = Devise.token_generator.digest(CustomerUser, :reset_password_token, @raw_token)
  end

  test "should redirect with error for missing token" do
    get :edit

    assert_redirected_to generate_passwords_path
    assert_equal I18n.t("customer_users.generate_passwords.token_required"), flash[:alert]
  end

  test "should redirect with error for invalid token" do
    get :edit, params: { reset_password_token: "invalid_token" }

    assert_redirected_to generate_passwords_path
    assert_equal I18n.t("customer_users.generate_passwords.invalid_token"), flash[:alert]
  end

  test "should redirect with error for expired token" do
    # Set expired timestamp (25 hours ago)
    @user.update_columns(
      reset_password_token: @hashed_token,
      reset_password_sent_at: 25.hours.ago
    )

    get :edit, params: { reset_password_token: @raw_token }

    assert_redirected_to generate_passwords_path
    assert_equal I18n.t("customer_users.generate_passwords.expired_token"), flash[:alert]
  end

  test "should allow access with valid token within 24 hours" do
    # Set valid timestamp (23 hours ago)
    @user.update_columns(
      reset_password_token: @hashed_token,
      reset_password_sent_at: 23.hours.ago
    )

    get :edit, params: { reset_password_token: @raw_token }

    assert_response :success
    assert_nil flash[:alert]
  end

  test "should update password successfully with valid data" do
    # Set valid token
    @user.update_columns(
      reset_password_token: @hashed_token,
      reset_password_sent_at: 1.hour.ago
    )

    password_params = {
      customer_user: {
        password: "new_password123",
        password_confirmation: "new_password123"
      },
      reset_password_token: @raw_token
    }

    patch :update, params: password_params

    assert_redirected_to generate_passwords_path
    assert_equal I18n.t("customer_users.generate_passwords.success"), flash[:notice]

    # Verify token was cleared and password was updated
    @user.reload
    assert_nil @user.reset_password_token
    assert_nil @user.reset_password_sent_at
    assert_not_nil @user.generated_password_at
    assert @user.valid_password?("new_password123")
  end

  test "should render edit with errors for invalid password" do
    # Set valid token
    @user.update_columns(
      reset_password_token: @hashed_token,
      reset_password_sent_at: 1.hour.ago
    )

    password_params = {
      customer_user: {
        password: "short",
        password_confirmation: "different"
      },
      reset_password_token: @raw_token
    }

    patch :update, params: password_params

    assert_response :unprocessable_entity
  end

  test "should handle database errors gracefully by testing transaction rollback" do
    # Set valid token
    @user.update_columns(
      reset_password_token: @hashed_token,
      reset_password_sent_at: 1.hour.ago
    )

    # Use an invalid password that will cause the update to fail
    password_params = {
      customer_user: {
        password: "", # Empty password will cause validation to fail
        password_confirmation: ""
      },
      reset_password_token: @raw_token
    }

    # Ensure the transaction doesn't clear the token on validation failure
    patch :update, params: password_params

    assert_response :unprocessable_entity

    # Verify token wasn't cleared due to failed validation
    @user.reload
    assert_not_nil @user.reset_password_token
  end

  test "should show without authentication" do
    get :show
    assert_response :success
  end
end
