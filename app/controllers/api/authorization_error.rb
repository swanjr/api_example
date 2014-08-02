module API
  class AuthorizationError < API::BaseError
    def initialize(developer_message)
      super(developer_message)
      @http_status_code = 403
      @code = :unauthorized_action
    end
  end
end
