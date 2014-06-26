class API::V1::AuthorizedUsersController < API::BaseController
  skip_before_action :restrict_access, only: [:create]

  def create
    authorized_user = Context::AuthenticateUser.authenticate(username_param,
                                                             password_param,
                                                             request.remote_ip)
    if authorized_user.present?
      respond_with authorized_user,
        :serializer => AuthorizedUserSerializer,
        :location => api_v1_authorized_user_url(authorized_user.id)
    else
      raise API::AuthenticationError.new("Invalid username or password")
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
