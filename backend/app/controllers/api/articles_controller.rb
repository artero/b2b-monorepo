class Api::ArticlesController < ApiController
  before_action :authenticate_user!

  def index
    products = load_mock_products
    render json: { products: products }
  end

  private

  def load_mock_products
    file_path = Rails.root.join("lib", "mock_products.json")
    JSON.parse(File.read(file_path))
  end
end
