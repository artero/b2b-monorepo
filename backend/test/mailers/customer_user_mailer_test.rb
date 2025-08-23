require "test_helper"

class CustomerUserMailerTest < ActionMailer::TestCase
  test "password_generation_instructions" do
    user = customer_users(:one)
    token = "sample-token"
    mail = CustomerUserMailer.password_generation_instructions(user, token)
    assert_equal "Genera tu contraseña - Acceso al sistema", mail.subject
    assert_equal [ user.email ], mail.to
    assert_equal [ "noreply@company.com" ], mail.from
    assert_match "Estimado cliente", mail.body.encoded
    assert_match token, mail.body.encoded
    assert_match "European Aerosols", mail.body.encoded
    assert_match "marketing@novasolspray.com", mail.body.encoded
    assert_match "24", mail.body.encoded
    assert_no_match "Pintyplus", mail.body.encoded
  end
end
