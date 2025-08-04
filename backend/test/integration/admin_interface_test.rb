require "test_helper"

class AdminInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = AdminUser.create!(
      email: 'test_admin@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test "admin can access dashboard after login" do
    # Visit admin root - should redirect to login
    get "/admin"
    assert_response :redirect
    assert_redirected_to new_admin_user_session_path

    # Login as admin user
    post admin_user_session_path, params: {
      admin_user: {
        email: @admin_user.email,
        password: 'password123'
      }
    }
    
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "title", "Dashboard | Admin"
  end

  test "non-admin cannot access admin interface" do
    get "/admin"
    assert_response :redirect
    assert_redirected_to new_admin_user_session_path
  end

  test "admin can access admin users management" do
    # Login first
    post admin_user_session_path, params: {
      admin_user: {
        email: @admin_user.email,
        password: 'password123'
      }
    }
    
    # Access admin users page
    get "/admin/admin_users"
    assert_response :success
    assert_select "title", "Admin Users | Admin"
  end

  test "admin interface includes required CSS and JS assets" do
    # Login first
    post admin_user_session_path, params: {
      admin_user: {
        email: @admin_user.email,
        password: 'password123'
      }
    }
    
    get "/admin"
    follow_redirect!
    
    # Check that ActiveAdmin CSS is loaded
    assert_select "link[href*='active_admin.css']"
  end
end