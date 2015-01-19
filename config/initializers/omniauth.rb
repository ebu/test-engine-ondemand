Rails.application.config.perform_omniauth_authentication = false
Rails.application.config.omniauth_strategy_url = 'developer'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer
end