module StoreUserRequestInfo
  extend ActiveSupport::Concern

  included do
    before_action :store_info
  end

  def store(symbol, value)
    # Use RequestStore gem to store in Thread.current
    RequestStore.store[symbol] = value
  end

  private

  def store_info
    if current_user
      store :username, current_user.username
      store :user_id, current_user.id
      store :auth_token, auth_token
    end
    store :request_id, request.uuid
    store :remote_ip, request.remote_ip
    store :user_agent, request.user_agent
  end
end
