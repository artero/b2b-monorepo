require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let!(:active_user) do
    create(:customer_user, password: "password123", password_confirmation: "password123")
  end

  let!(:blocked_user) do
    create(:customer_user, :blocked, password: "password123", password_confirmation: "password123")
  end

  describe "POST /auth/sign_in" do
    context "with valid credentials" do
      it "returns auth tokens and user data" do
        post "/auth/sign_in", params: {
          email: active_user.email,
          password: "password123"
        }

        expect(response).to have_http_status(:ok)

        # Check that auth headers are present
        expect(response.headers["access-token"]).to be_present
        expect(response.headers["client"]).to be_present
        expect(response.headers["uid"]).to be_present
        expect(response.headers["uid"]).to eq(active_user.email)

        # Check response body contains user data
        json_response = JSON.parse(response.body)
        expect(json_response["data"]).to be_present
        expect(json_response["data"]["email"]).to eq(active_user.email)
        expect(json_response["data"]["name"]).to eq(active_user.name)
        expect(json_response["data"]["surname"]).to eq(active_user.surname)
      end
    end

    context "with non-existent user" do
      it "returns unauthorized" do
        post "/auth/sign_in", params: {
          email: "nonexistent@example.com",
          password: "password123"
        }

        expect(response).to have_http_status(:unauthorized)

        # Check that no auth headers are present
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response.headers["uid"]).to be_blank

        # Check error message
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to be_present
      end
    end

    context "with blocked user" do
      it "returns unauthorized" do
        post "/auth/sign_in", params: {
          email: blocked_user.email,
          password: "password123"
        }

        expect(response).to have_http_status(:unauthorized)

        # Check that no auth headers are present
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response.headers["uid"]).to be_blank
      end
    end

    context "with incorrect email" do
      it "returns unauthorized" do
        post "/auth/sign_in", params: {
          email: "wrong@example.com",
          password: "password123"
        }

        expect(response).to have_http_status(:unauthorized)

        # Check that no auth headers are present
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response.headers["uid"]).to be_blank
      end
    end

    context "with incorrect password" do
      it "returns unauthorized" do
        post "/auth/sign_in", params: {
          email: active_user.email,
          password: "wrongpassword"
        }

        expect(response).to have_http_status(:unauthorized)

        # Check that no auth headers are present
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response.headers["uid"]).to be_blank
      end
    end
  end

  describe "DELETE /auth/sign_out" do
    context "with valid tokens" do
      it "successfully logs out" do
        # First login to get tokens
        post "/auth/sign_in", params: {
          email: active_user.email,
          password: "password123"
        }

        expect(response).to have_http_status(:ok)

        # Extract tokens from login response
        access_token = response.headers["access-token"]
        client = response.headers["client"]
        uid = response.headers["uid"]

        # Now logout
        delete "/auth/sign_out", headers: {
          "access-token" => access_token,
          "client" => client,
          "uid" => uid
        }

        expect(response).to have_http_status(:ok)
      end
    end

    context "without tokens" do
      it "returns not found" do
        delete "/auth/sign_out"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /auth/validate_token" do
    context "with valid tokens" do
      it "returns success and user data" do
        # First login to get tokens
        post "/auth/sign_in", params: {
          email: active_user.email,
          password: "password123"
        }

        expect(response).to have_http_status(:ok)

        # Extract tokens from login response
        access_token = response.headers["access-token"]
        client = response.headers["client"]
        uid = response.headers["uid"]

        # Validate token
        get "/auth/validate_token", headers: {
          "access-token" => access_token,
          "client" => client,
          "uid" => uid
        }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be true
        expect(json_response["data"]).to be_present
        expect(json_response["data"]["email"]).to eq(active_user.email)
      end
    end

    context "with invalid tokens" do
      it "returns unauthorized" do
        get "/auth/validate_token", headers: {
          "access-token" => "invalid",
          "client" => "invalid",
          "uid" => "invalid@example.com"
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
