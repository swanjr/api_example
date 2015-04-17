module API
  class AuthorizationError < API::BadRequestError
    def initialize(developer_message, code = :unauthorized_action)
      super(developer_message, 403)
      @code = code
    end
  end
end
