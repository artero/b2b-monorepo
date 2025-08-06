require "test_helper"

class AdminAuthorizationAdapterTest < ActiveSupport::TestCase
  def setup
    @regular_admin = admin_users(:one)
    @super_admin = admin_users(:super_admin)
  end

  # Tests for AdminUser subject
  test "allows read access to AdminUser for any admin" do
    adapter = AdminAuthorizationAdapter.new(nil, @regular_admin)
    assert adapter.authorized?(:read, AdminUser)
    assert adapter.authorized?(:read, @regular_admin)
  end

  test "allows read access to AdminUser for super admin" do
    adapter = AdminAuthorizationAdapter.new(nil, @super_admin)
    assert adapter.authorized?(:read, AdminUser)
    assert adapter.authorized?(:read, @super_admin)
  end

  test "denies create access to AdminUser for regular admin" do
    adapter = AdminAuthorizationAdapter.new(nil, @regular_admin)
    refute adapter.authorized?(:create, AdminUser)
    refute adapter.authorized?(:create, @regular_admin)
  end

  test "allows create access to AdminUser for super admin" do
    adapter = AdminAuthorizationAdapter.new(nil, @super_admin)
    assert adapter.authorized?(:create, AdminUser)
    assert adapter.authorized?(:create, @super_admin)
  end

  test "denies destroy access to AdminUser for regular admin" do
    adapter = AdminAuthorizationAdapter.new(nil, @regular_admin)
    refute adapter.authorized?(:destroy, AdminUser)
    refute adapter.authorized?(:destroy, @regular_admin)
  end

  test "allows destroy access to AdminUser for super admin" do
    adapter = AdminAuthorizationAdapter.new(nil, @super_admin)
    assert adapter.authorized?(:destroy, AdminUser)
    assert adapter.authorized?(:destroy, @super_admin)
  end

  test "allows update access to AdminUser for super admin on any user" do
    adapter = AdminAuthorizationAdapter.new(nil, @super_admin)
    assert adapter.authorized?(:update, AdminUser)
    assert adapter.authorized?(:update, @regular_admin)
    assert adapter.authorized?(:update, @super_admin)
  end

  test "allows update access to AdminUser for regular admin on themselves" do
    adapter = AdminAuthorizationAdapter.new(nil, @regular_admin)
    assert adapter.authorized?(:update, @regular_admin)
  end

  test "denies update access to AdminUser for regular admin on other users" do
    adapter = AdminAuthorizationAdapter.new(nil, @regular_admin)
    refute adapter.authorized?(:update, @super_admin)
    refute adapter.authorized?(:update, AdminUser)
  end

  test "denies custom actions on AdminUser for regular admin" do
    adapter = AdminAuthorizationAdapter.new(nil, @regular_admin)
    refute adapter.authorized?(:custom_action, AdminUser)
    refute adapter.authorized?(:some_other_action, @regular_admin)
  end

  test "allows custom actions on AdminUser for super admin" do
    adapter = AdminAuthorizationAdapter.new(nil, @super_admin)
    assert adapter.authorized?(:custom_action, AdminUser)
    assert adapter.authorized?(:some_other_action, @regular_admin)
  end

  # Tests for non-AdminUser subjects
  test "allows all actions on non-AdminUser subjects" do
    adapter = AdminAuthorizationAdapter.new(nil, @regular_admin)

    # Test with various subjects
    assert adapter.authorized?(:read, "SomeOtherResource")
    assert adapter.authorized?(:create, "SomeOtherResource")
    assert adapter.authorized?(:update, "SomeOtherResource")
    assert adapter.authorized?(:destroy, "SomeOtherResource")
    assert adapter.authorized?(:custom_action, "SomeOtherResource")
  end

  test "allows all actions on non-AdminUser subjects for super admin" do
    adapter = AdminAuthorizationAdapter.new(nil, @super_admin)

    assert adapter.authorized?(:read, "SomeOtherResource")
    assert adapter.authorized?(:create, "SomeOtherResource")
    assert adapter.authorized?(:update, "SomeOtherResource")
    assert adapter.authorized?(:destroy, "SomeOtherResource")
    assert adapter.authorized?(:custom_action, "SomeOtherResource")
  end

  # Tests for nil user
  test "handles nil user gracefully" do
    adapter = AdminAuthorizationAdapter.new(nil, nil)

    # Should deny AdminUser actions when user is nil
    refute adapter.authorized?(:create, AdminUser)
    refute adapter.authorized?(:destroy, AdminUser)
    refute adapter.authorized?(:update, AdminUser)
    refute adapter.authorized?(:custom_action, AdminUser)

    # Should still allow read access
    assert adapter.authorized?(:read, AdminUser)

    # Should allow non-AdminUser subjects
    assert adapter.authorized?(:read, "SomeOtherResource")
  end

  # Edge cases
  test "handles nil subject gracefully" do
    adapter = AdminAuthorizationAdapter.new(nil, @regular_admin)

    # Should allow nil subject (non-AdminUser case)
    assert adapter.authorized?(:read, nil)
    assert adapter.authorized?(:create, nil)
  end

  test "handles empty subject gracefully" do
    adapter = AdminAuthorizationAdapter.new(nil, @regular_admin)

    # Should allow empty subject (non-AdminUser case)
    assert adapter.authorized?(:read, "")
    assert adapter.authorized?(:create, "")
  end
end
