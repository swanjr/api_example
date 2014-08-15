# ESP system id and password
esp_system_id = Rails.application.secrets.esp_system_id
auth_system_password = Rails.application.secrets.auth_system_password

# Reload config in development if files change
Rails.application.config.to_prepare do

  Security::GettyToken.configure do |config|
    config.get_user_token_endpoint = Rails.application.config.endpoints[:get_user_token]
    config.auth_system_id = esp_system_id
    config.auth_system_password = auth_system_password
  end

end

