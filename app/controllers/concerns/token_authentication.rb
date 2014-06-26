module TokenAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :restrict_access
  end

  def current_user
    @current_user
  end

  private

  def restrict_access
    token = header_token
    token = request_token unless token
    token.gsub!(/'/, '') if token

    @current_user = Context::AuthenticateUser.authenticate_token(token)
    raise API::AuthenticationError.new("Invalid authentication token") if @current_user.nil?
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
