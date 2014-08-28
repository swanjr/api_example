class API::V1::AuthorizedUsersController < API::BaseController
  skip_before_action :restrict_access, only: [:create]

  def create
    authorized_user = AuthenticateUser.authenticate(params[:username],
                                                             params[:password],
                                                             request.remote_ip)
    if authorized_user.present?
      respond_with authorized_user.extend(AuthorizedUserRepresenter),
        location: api_v1_authorized_user_url(authorized_user.id)
    else
      raise API::AuthenticationError.new("Invalid username or password")
    end
  end

end
