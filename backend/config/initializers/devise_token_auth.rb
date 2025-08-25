# Minimal DeviseTokenAuth configuration
DeviseTokenAuth.setup do |config|
  # Basic token configuration
  config.change_headers_on_each_request = true
  config.token_lifespan = 2.weeks

  # Allow legacy Devise support
  config.enable_standard_devise_support = true
end
