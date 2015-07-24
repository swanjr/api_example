module UserAuthorization
  extend ActiveSupport::Concern

  included do
    after_action :verify_authorized
  end

  def authorize(permission_name, user = current_user)
    raise API::AuthorizationError.new(
      "User '#{current_user.username}' does not have access to perform this action."
    ) unless user.has_permission?(permission_name)

    @user_authorized = true
  end

  def skip_authorization
    @user_authorized = true
  end

  private

  def verify_authorized
    raise AuthorizationNotVerifiedError.new(
      "Failed to verify user has access to feature.") unless @user_authorized
  end
end

class AuthorizationNotVerifiedError < StandardError
end
