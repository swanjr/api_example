Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # ESP enterprise id prefix
  config.enterprise_id_prefix = "ESPIDTEST"

  # Third party endpoints
  config.endpoints[:get_system_token] = "http://entsvca.candidate-gettyimages.com/SecurityToken/json/3.0/GetSystemToken"
  config.endpoints[:renew_token] = "http://entsvca.candidate-gettyimages.com/SecurityToken/json/3.0/RenewToken"
  config.endpoints[:event] = "http://eventsvc.test.gettyimages.com/Event/json/2.0"
  config.endpoints[:dsa] = "http://dsa-candidate.gettyimages.io/assets"

  # Override Ffprober's default timeout of 30 seconds only in development/test
  Ffprober::Parser.timeout = 600

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance.
  #config.serve_static_assets  = true
  config.static_cache_control = 'public, max-age=3600'

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false
  config.action_controller.action_on_unpermitted_parameters = :raise

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = true

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  #config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr
end
