class API::BaseController < ActionController::Metal
  # Include only need modules from ActionController::Base
  ActionController::Base.without_modules(
    'AbstractController::Translation',
    'AbstractController::AssetPaths',
    'ConditionalGet',
    'Helpers',
    'HideActions',
    'ActionView::Layouts',
    'Caching',
    'Cookies',
    'Flash',
    'Streaming',
    'HttpAuthentication::Digest::ControllerMethods',
    'HttpAuthentication::Basic::ControllerMethods',
    'AbstractController::Callbacks'
  ).each do |left|
    include left
  end
  include Rails.application.routes.url_helpers

  ActiveSupport.run_load_hooks(:action_controller, self)

  # Concerns
  include UseSsl
  include TokenAuthentication     # Prepended to guarantee it is first
  include StoreUserRequestInfo    # Before action to store user info
  include RestSearchParams
  include ModelRendering
  include ErrorMapper

  protect_from_forgery with: :null_session
end
