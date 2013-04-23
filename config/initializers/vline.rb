require 'vline'

Vline.setup do |config|

  config.service_id = 'YOUR_SERVICE_ID'             # See vLine Developer Console
  config.provider_id = 'YOUR_PROVIDER_ID'           # Usually same as service_id
  config.client_id = 'YOUR_OAUTH_CLIENT_ID'         # Random string you generate: ruby -e "require 'securerandom'; puts SecureRandom.urlsafe_base64(32)"

  # WARNING: Do not check these values into VCS! 
  config.client_secret = 'YOUR_OAUTH_CLIENT_SECRET'   # Random string you generate: ruby -e "require 'securerandom'; puts SecureRandom.urlsafe_base64(32)"
  config.provider_secret = 'YOUR_SERVICE_API_SECRET'  # See vLine Developer Console
end
