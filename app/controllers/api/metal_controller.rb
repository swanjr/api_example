class API::MetalController < ActionController::Metal
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
end
