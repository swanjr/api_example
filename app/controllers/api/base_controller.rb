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
    'HttpAuthentication::Digest::ControllerMethods.inspectuthentication::Basic::ControllerMethods',
    'AbstractController::Callbacks'
  ).each do |left|
    include left
  end
  include Rails.application.routes.url_helpers

  ActiveSupport.run_load_hooks(:action_controller, self)

  # Responder raises resource errors as a API::ValidationError
  self.responder = Responder::Master

  # Concerns
  include UseSsl
  include TokenAuthentication

  protect_from_forgery with: :null_session

  respond_to :json

  # Disabled default automatic param parsing and overrode default params method.
  # Doing this to we aren't parsing the json multiple times for controllers using Representable.
  def params
    @cached_params ||= super.merge(parse_json_request)
  end

  private

  def parse_json_request
    data = ActiveSupport::JSON.decode(request.raw_post)
    data = {:_json => data} unless data.is_a?(Hash)
    ActionDispatch::Request::Utils.deep_munge(data).with_indifferent_access
  end
end
