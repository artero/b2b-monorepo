require "test_helper"

class AdminInterfaceTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  test "admin can access dashboard after login" do
    visit new_admin_user_session_path

    fill_in "Email", with: admin_users(:one).email
    fill_in "Contraseña", with: "password123"
    click_button "Iniciar Sesión"

    assert_current_path admin_root_path
    assert page.has_content?("B2B webshop Admin")
    assert page.has_no_content?("Iniciar Sesión")
  end

  test "admin user can use forgot password link and serd email" do
    visit new_admin_user_session_path

    assert_current_path new_admin_user_session_path

    click_link "¿Olvidó su contraseña?"

    assert_current_path new_admin_user_password_path

    # Clear any existing emails
    ActionMailer::Base.deliveries.clear

    fill_in "Email", with: admin_users(:one).email
    click_button "Restablecer mi contraseña"

    # Verify email was sent
    assert_equal 1, ActionMailer::Base.deliveries.size

    email = ActionMailer::Base.deliveries.last
    assert_equal [ admin_users(:one).email ], email.to
    assert_match(/(reset.*password|recuperación.*contraseña)/i, email.subject)
    assert_match(/(reset.*password|recuperación.*contraseña|restablecer)/i, email.body.to_s)
  end
end
