class API::BaseController < API::MetalController

  # Concerns
  include UseSsl
  include TokenAuthentication     # Prepended to guarantee it is first
  include StoreUserRequestInfo    # Before action to store user info
  include UserAuthorization       # Adds authorize method and authorization enforcement
  include RestSearchParams        # Parses REST query search params
  include ModelRendering          # Provided model rending helpers
  include ErrorMapper             # Maps errors to appropriate API error classes

  protect_from_forgery with: :null_session
end
