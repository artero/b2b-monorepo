require 'rails_helper'

RSpec.describe HealthController, type: :controller do
  describe "routing" do
    it "routes GET /health to health#index" do
      expect(get: "/health").to route_to(controller: "health", action: "index")
    end
  end
end
