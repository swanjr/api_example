source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
gem 'puma'
gem 'active_model_serializers'
gem 'rest-client'
gem 'ffprober', path: 'vendor/bundle/ffprober'
gem 'fog'
gem 'unf' # Required for fog
gem 'getty-instrumentation', path: 'vendor/bundle/getty-instrumentation'

gem 'mysql2', platform: :ruby
gem 'activerecord-jdbcmysql-adapter', platform: :jruby

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'pry-rails'
end

group :test do
  gem 'shoulda', :require => false
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'psych', '>= 2.0.5'
  gem 'webmock'
end

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
