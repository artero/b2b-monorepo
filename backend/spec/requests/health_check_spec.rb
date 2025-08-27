require 'rails_helper'

RSpec.describe "Health Check", type: :request do
  describe "GET /health" do
    it "returns OK status with JSON response" do
      get health_check_path

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("ok")
    end
  end
end
