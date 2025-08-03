require "test_helper"

class HealthControllerTest < ActionController::TestCase
  test "should have proper route configured" do
    assert_routing "/health", controller: "health", action: "index"
  end
end
