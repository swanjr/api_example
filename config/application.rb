require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "representable/json"

# require "action_mailer/railtie"
# require "action_view/railtie"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EspAPI
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Load added directories
    #config.autoload_paths += %W(#{config.root}/app/commands)
    config.autoload_paths += %W(#{config.root}/app/contexts)
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/middleware)

    # Remove middleware
    config.middleware.delete "Rack::Lock"
    config.middleware.delete "ActionDispatch::Static"
    config.middleware.delete "ActionDispatch::Cookies"
    config.middleware.delete "ActionDispatch::Session::CookieStore"
    config.middleware.delete "ActionDispatch::Flash"
    config.middleware.delete "ActionDispatch::BestStandardsSupport"
    config.middleware.delete "Rack::MethodOverride"
    config.middleware.delete "ActionDispatch::ParamsParser"

    # Configure exceptions app to handle all uncaught errors
    config.exceptions_app = lambda do |env|
      ExceptionRenderer.new.call(env)
    end

    # Default generators
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets = false
      g.helper = false
      g.helper_specs false
      g.view_specs false
    end

    # Initialize endpoints hash for use in environment files
    config.endpoints = {}
  end
end
