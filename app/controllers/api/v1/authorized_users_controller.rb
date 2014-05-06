class API::V1::AuthorizedUsersController < API::BaseController

  def create
    authorized_user = Context::AuthenticateUser.authenticate(username_param, password_param)

    if authorized_user.present?
      respond_with authorized_user,
        :serializer => AuthorizedUserSerializer,
        :location => api_v1_authorized_user_url(authorized_user)
    else
      raise AuthenticationError.new("Invalid username or password")
    end
  end

  private

  def username_param
    params.require('username')
  end

  def password_param
    params.require('password')
  end
end
