
Hcaptcha.configure do |config|
  config.site_key = Rails.application.credentials.dig(:hcaptcha_public)
  config.secret_key = Rails.application.credentials.dig(:hcaptcha_secret)
end
