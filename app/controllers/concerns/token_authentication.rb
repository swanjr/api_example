module TokenAuthentication
  extend ActiveSupport::Concern

  included do
    prepend_before_action :restrict_access
  end

  def current_user
    @current_user
  end

  def auth_token
    @auth_token
  end

  private

  def restrict_access
    token = header_token
    token = cookie_token unless token
    token = request_token unless token

    raise API::AuthenticationError.new("Authentication token missing", 
                                       :auth_token_missing) unless token.present?

    token.gsub!(/'/, '')

    begin
      getty_token = Security::GettyToken.new(token)
    rescue Security::MalformedTokenError
      # Check if token is URI encoded.
      getty_token = Security::GettyToken.new(URI.decode(token))
    end

    if getty_token.expired?
      getty_token = Security::GettyToken.renew(getty_token.value)
    end

    if getty_token.present? && getty_token.valid?
      @auth_token = getty_token.value
      @current_user = User.for_account_number(getty_token.account_number)

      #Set user cookies for clients that need them
      set_user_cookies
    end

    raise API::AuthenticationError.new("Invalid authentication token") unless @auth_token.present?
    raise API::AuthenticationError.new("User account not found", 
                                       :account_not_found) unless @current_user.present?
  end

  def header_token
    authenticate_with_http_token do |token, options|
      token
    end
  end

  def cookie_token
    cookies[:auth]
  end

  def request_token
    params[:request_header][:token] unless params[:request_header].blank?
  end

  def set_user_cookies
    if current_user.present?
      set_cookie(:auth, auth_token, true)
      set_cookie(:account_number, current_user.account_number)
      set_cookie(:user_id, current_user.id)
      set_cookie(:username, current_user.username)
    end
  end

  def set_cookie(name, value, http_only = false)
    cookies[name] = {
      secure: secure?,
      value: value,
      expires: 1.week.from_now, # any value greater than/equal to 12 hours
      domain: ".#{request.domain}",
      path: "/",
      httponly: http_only
    }
  end

  def secure?
    Rails.env.production? || Rails.env.candidate?
  end
end
