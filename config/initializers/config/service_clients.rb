# ESP system id and password
esp_system_id = Rails.application.secrets.esp_system_id
auth_system_password = Rails.application.secrets.auth_system_password

# Reload config in development if files change
Rails.application.config.to_prepare do

  Security::GettyToken.config = {
    get_system_token_endpoint: Rails.configuration.endpoints[:get_system_token],
    renew_token_endpoint: Rails.configuration.endpoints[:renew_token],
    auth_system_id: esp_system_id,
    auth_system_password: auth_system_password
  }

end

