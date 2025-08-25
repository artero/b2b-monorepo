class Auth::SessionsController < DeviseTokenAuth::SessionsController
  include DeviseTokenAuth::Concerns::SetUserByToken

  # Skip CSRF protection for API requests
  protect_from_forgery with: :null_session

  # Ensure we respond as JSON
  respond_to :json
end
