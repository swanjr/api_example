# Reload config in development if files change
Rails.application.config.to_prepare do
  RestSearchParams.filter_operators = Queries::DynamicSearch.valid_operators
end
