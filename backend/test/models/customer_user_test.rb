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
end
