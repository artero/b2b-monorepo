require "test_helper"

class CustomerUserMailerTest < ActionMailer::TestCase
  test "password_generation_instructions" do
    mail = CustomerUserMailer.password_generation_instructions
    assert_equal "Password generation instructions", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
