# Reload config in development if files change
Rails.application.config.to_prepare do

  Security::GettyTokenAnalyzer.configure do |config|
    config.sts_public_key = Rails.application.secrets.sts_public_key
  end

end
