require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]


  test "admin user can login through the login form interface" do
    visit new_admin_user_session_path

    assert_current_path new_admin_user_session_path

    fill_in "Email", with: admin_users(:one).email
    fill_in "Password", with: "password123"
    click_button "Sign In"

    assert_current_path admin_root_path
    assert page.has_content?("Dashboard"), "Should be redirected to admin dashboard after successful login"
  end
end
