# Configured mappings to convert thrown errors to appropriate API level errors
# that can be returned to clients

# Reload config in development if files change
Rails.application.config.to_prepare do

  ExceptionRenderer.configure do |config|
    config.error_mappings = {
      'Esp::UnknownUserError' => API::AuthorizationError.new('User has not been registered with the system.')
    }
  end

end
