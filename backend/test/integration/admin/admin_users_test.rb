require "test_helper"

class AdminUsersTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  test "admin can access admin users section after login" do
    visit new_admin_user_session_path

    fill_in "Email", with: admin_users(:super_admin).email
    fill_in "Contraseña", with: "password123"
    click_button "Iniciar Sesión"

    assert_current_path admin_root_path

    visit admin_admin_users_path

    assert_current_path admin_admin_users_path
    assert page.has_content?("Admin Users")
    assert page.has_content?(admin_users(:one).email)
  end
end
