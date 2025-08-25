require "test_helper"

class ArticlesTest < ActionDispatch::IntegrationTest
  def setup
    @active_user = customer_users(:one)
    @active_user.update!(
      password: "password123",
      password_confirmation: "password123"
    )

    @blocked_user = customer_users(:two)
    @blocked_user.update!(
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "authenticated request returns articles with valid token" do
    # Login to get tokens
    post "/auth/sign_in", params: {
      email: @active_user.email,
      password: "password123"
    }

    assert_response :ok

    # Extract tokens
    access_token = response.headers["access-token"]
    client = response.headers["client"]
    uid = response.headers["uid"]

    # Request articles with authentication
    get "/api/articles", headers: {
      "access-token" => access_token,
      "client" => client,
      "uid" => uid
    }

    assert_response :ok

    json_response = JSON.parse(response.body)

    # Check that we get an array of products
    assert json_response["products"].is_a?(Array)
    assert json_response["products"].length == 10

    # Check first product has required attributes
    first_product = json_response["products"].first
    assert first_product["code"].present?
    assert first_product["name"].present?
    assert first_product["brand"] == "PintyPlus"
    assert first_product["size"].present?
    assert first_product["color"].present?
    assert first_product["family"].present?
    assert first_product["units_per_box"].present?
    assert first_product["price"].present?
  end

  test "unauthenticated request returns unauthorized error" do
    get "/api/articles"

    assert_response :unauthorized
  end

  test "request with invalid token returns unauthorized error" do
    get "/api/articles", headers: {
      "access-token" => "invalid_token",
      "client" => "invalid_client",
      "uid" => "invalid@example.com"
    }

    assert_response :unauthorized
  end
end
