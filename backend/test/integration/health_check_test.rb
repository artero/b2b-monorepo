require "test_helper"

class HealthCheckTest < ActionDispatch::IntegrationTest
  test "should handle GET request to health endpoint" do
    get health_check_path

    assert_equal "application/json; charset=utf-8", response.content_type
    assert_response :ok

    json_response = JSON.parse(response.body)
    assert_equal "ok", json_response["status"]
  end
end
