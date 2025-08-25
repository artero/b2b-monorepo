require "test_helper"

class CustomerUserTest < ActiveSupport::TestCase
  test "full_name returns concatenated name and surname" do
    user = customer_users(:one)
    assert_equal "John Doe", user.full_name
  end

  test "full_name strips whitespace" do
    user = customer_users(:with_whitespace)
    assert_equal "Alice Brown", user.full_name
  end

  test "full_name handles empty name" do
    user = customer_users(:with_empty_name)
    assert_equal "Johnson", user.full_name
  end

  test "full_name handles empty surname" do
    user = customer_users(:with_empty_surname)
    assert_equal "Bob", user.full_name
  end

  test "generated_password_at is present when password was generated" do
    user = customer_users(:one)
    assert_not_nil user.generated_password_at
    assert user.generated_password_at < Time.current
  end

  test "generated_password_at is nil when password was not generated" do
    user = customer_users(:two)
    assert_nil user.generated_password_at
  end

  test "generated_password_at tracks recent password generation" do
    user = customer_users(:recently_generated_password)
    assert_not_nil user.generated_password_at
  end

  test "send_password_generation_instructions generates token and sets timestamp" do
    user = customer_users(:two)

    assert_nil user.reset_password_token
    assert_nil user.reset_password_sent_at

    result = user.send_password_generation_instructions

    assert result
    assert_not_nil user.reset_password_token
    assert_not_nil user.reset_password_sent_at
    assert_nil user.generated_password_at
    assert user.reset_password_sent_at <= Time.now.utc
    assert user.reset_password_sent_at >= 1.minute.ago.utc
  end

  test "send_password_generation_instructions sends email" do
    user = customer_users(:two)

    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      user.send_password_generation_instructions
    end
  end

  test "send_password_generation_instructions returns false on validation error" do
    user = customer_users(:two)
    user.email = nil

    result = user.send_password_generation_instructions

    assert_not result
  end

  test "send_password_generation_instructions clears generated_password_at" do
    user = customer_users(:one)
    assert_not_nil user.generated_password_at

    user.send_password_generation_instructions
    user.reload

    assert_nil user.generated_password_at
  end

  test "token is valid within 24 hours" do
    user = customer_users(:two)
    user.send_password_generation_instructions

    # Simulate token generated 23 hours ago
    user.update_column(:reset_password_sent_at, 23.hours.ago)

    # Token should still be valid
    assert user.reset_password_sent_at >= Devise.reset_password_within.ago
  end

  test "token expires after 24 hours" do
    user = customer_users(:two)
    user.send_password_generation_instructions

    # Simulate token generated 25 hours ago
    user.update_column(:reset_password_sent_at, 25.hours.ago)

    # Token should be expired
    assert user.reset_password_sent_at < Devise.reset_password_within.ago
  end
end
