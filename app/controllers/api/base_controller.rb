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

  ActiveSupport.run_load_hooks(:action_controller, self)

  protect_from_forgery with: :null_session

  respond_to :json

  before_action :restrict_access

  def current_user
    @current_user
  end

  private

  def restrict_access
    token = header_token
    token = request_token unless token

    @current_user = Context::AuthenticateUser.authenticate_token(token)
    raise AuthenticationError.new("Invalid authentication token") if @current_user.nil?
  end

  def header_token
    authenticate_with_http_token do |token, options|
      token
    end
  end

  def request_token
    params[:request_header][:token] unless params[:request_header].blank?
  end

end
