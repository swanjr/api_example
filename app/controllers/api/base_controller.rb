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

  # Concerns
  include UseSsl
  include TokenAuthentication

  ActiveSupport.run_load_hooks(:action_controller, self)

  protect_from_forgery with: :null_session

  respond_to :json

  # Responder raises resource errors as a ValidationError
  self.responder = JSONErrorsResponder
end
