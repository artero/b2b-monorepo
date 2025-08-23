require "test_helper"

class CustomerUserMailerTest < ActionMailer::TestCase
  test "password_generation_instructions" do
    user = customer_users(:one)
    token = "sample-token"
    mail = CustomerUserMailer.password_generation_instructions(user, token)
    assert_equal "Genera tu contraseña - Acceso al sistema", mail.subject
    assert_equal [ user.email ], mail.to
    assert_equal [ "noreply@company.com" ], mail.from
    assert_match "Hola", mail.body.encoded
    assert_match token, mail.body.encoded
  end
end
