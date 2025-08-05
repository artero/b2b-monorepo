require "test_helper"

class AdminInterfaceTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "admin can access dashboard after login" do
    visit new_admin_user_session_path

    assert_current_path new_admin_user_session_path

    fill_in "Email", with: admin_users(:one).email
    fill_in "Password", with: "password123"
    click_button "Sign In"

    assert_current_path admin_root_path
  end
end
