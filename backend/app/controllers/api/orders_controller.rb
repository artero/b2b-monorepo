class Api::OrdersController < ApiController
  before_action :authenticate_customer_user!

  def index
    orders = load_mock_orders
    render json: { orders: orders }
  end

  def create
    render json: { message: "Order created successfully", order_id: "1234" }, status: :created
  end

  private

  def load_mock_orders
    file_path = Rails.root.join("lib", "mock_orders.json")
    data = JSON.parse(File.read(file_path))
    data["rows"]
  end
end
