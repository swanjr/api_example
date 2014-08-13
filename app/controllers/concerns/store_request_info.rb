module StoreRequestInfo
  extend ActiveSupport::Concern

  included do
    before_filter :store_request_info
  end

  private

  def store_request_info
    if current_user
      Thread.current[:username] = current_user.username
      Thread.current[:user_id] = current_user.id
    end
    Thread.current[:request_id] = request.uuid
    Thread.current[:remote_ip] = request.remote_ip
    Thread.current[:user_agent] = request.user_agent
  end

end
