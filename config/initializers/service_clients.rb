#Configure service client models

# ESP system id and password
auth_system_id = Rails.application.secrets.auth_system_id
auth_system_password = Rails.application.secrets.auth_system_password

# Reload config in development if files change
Rails.application.config.to_prepare do

  Security::GettyToken.configure do |config|
    config.endpoint = Rails.application.config.endpoints[:create_session]
    config.auth_system_id = auth_system_id
    config.auth_system_password = auth_system_password
  end

end

